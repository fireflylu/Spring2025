import sys
import ssl
import string
from socket import *


def req_resp(s, host, prof):
    req = f"HEAD {prof} HTTP/1.1\r\nHost: {host}\r\n\r\n"
    print("---Request Begin---")
    print(f"HEAD {prof} HTTP/1.1\nHost: {host}\nConnection: keep-alive\n")
    s.send(req.encode()) # Send request
    data = s.recv(4096).decode() # Get response
    s.close()
    print("---Request End---")
    print("HTTP request sent, awaiting response...\n")

    resp_body = False
    data = data.split("\r\n")
    print("---Response Header---")
    for x in data:
        if x == "" and resp_body == True:
            print("\n---Response Body---")
            break
        elif x == "": resp_body = False
        print(x)
    print("---Response End---\n")
    return(data)

def host_prof(input):
    for i, x in enumerate(input):
        if x == "/":
            host = input[:i]
            prof = input[i:]
            break
        elif i == len(input)-1:
            host = input
            prof = "/"
    # print(host, prof)
    return host, prof

def parse_cookie(cookie):
    cookie = cookie[12:]
    for i, x in enumerate(cookie):
        if x == "=":
            name = cookie[:i]
            cookie = cookie[i:]
            break

    index = cookie.find('expires')
    if index != -1:
        expire = cookie[index+8:]
        for i, x in enumerate(expire):
            if x == ";":
                expire = expire[:i]
                break
    else:
        expire = None

    
    index = cookie.find("domain")
    if index != -1:
        domain = cookie[index+7:]
        # print(domain)
        for i, x in enumerate(domain):
            if x == ";":
                domain = domain[:i]
                break
    else: domain = None
    
    return name, expire, domain


v_arg = False
# check command line arguments; length should be 2
if len(sys.argv) < 2:
    print("No URI was provided to the program")
elif len(sys.argv) > 2:
    print("Additional arguments were provided to the program. Provide only one URI")
else:
    v_arg = True


# initial connection
host, prof = host_prof(sys.argv[1])
if v_arg == True:
    s = socket(AF_INET,SOCK_STREAM)
    # print("---Attempting Connection---")
    try:
        s.connect((host, 80)) # Connect
    except:
        v_arg = False
        print("Unable to establish connection with URI")
    else:
        data = req_resp(s, host, prof)


http = "http"
index = 0
# if redirect is necessary
while "3" == data[0][9]:
    print("Error " + data[0][9:])
    v_arg = False
        # break

    print("---Redirecting---")
    for x in data:
        if "Location: " in x:
            http = x[10:]
            new_addr = x[18:]
            break
    host, prof = host_prof(new_addr)
    for i, x in enumerate(http):
        if x == ":":
            http = http[:i]
    print("---New host and profile received---")
    print(f"{host}{prof}")
    print()

    if http == "https":
        context = ssl.create_default_context()
        conn = context.wrap_socket(socket(AF_INET), server_hostname=host)
        try:
            conn.connect((host, 443))
        except:
            print("Unable to establish connection with URI")
            v_arg = False
            break
        else: 
            data = req_resp(conn, host, prof)

    else: 
        conn = socket(AF_INET,SOCK_STREAM)
        try:
            conn.connect((host, 80))
        except:
            v_arg = False
            print("Unable to establish connection with URI")
            break
        else:
            data = req_resp(conn, host, prof)
    v_arg = True


if v_arg != False:
    h2_support = False
    pwp = False

    # check if server supports http2
    context = ssl.create_default_context()
    context.set_alpn_protocols(['http/1.1', 'h2'])
    conn = context.wrap_socket(socket(AF_INET), server_hostname=host)
    try:
        conn.connect((host, 443))
    except:
        v_arg = False
        print("http2: Unable to establish connection with URI")
    else:
        negotiated_protocol = conn.selected_alpn_protocol()
        if 'h2' == negotiated_protocol:
            h2_support = True
    conn.close()

    # Check if password protected (error 401)
    if "401" in data[0]:
        pwp = True

    ######################################################################
    # print("-----------------------------------------------------------")
    ######################################################################

    # Given Url:
    print(f"website: {host}")

    # part 1
    if h2_support == False:
        print(f"1. Supports http2: no")
    elif h2_support == True: 
        print(f"1. Supports http2: yes")

    #part 2
    print("2. List of cookies:")
    for x in data:
        # print(x)
        if x == "":
            break
        if "Set-Cookie: " in x:
            cookie = x
            name, expire, domain = parse_cookie(x)
            cookie_info = f"cookie name: {name}"
            if expire != None:
                cookie_info += f", expires: {expire}"
            if domain != None: 
                cookie_info += f", domain: {domain}"
            print(cookie_info)

    # part 3
    if pwp == False:
        print(f"3. password-protected: no")
    elif pwp == True: 
        print(f"3. password-protected: yes")

