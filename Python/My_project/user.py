import sys
class User():
   
    def __init__(self,**dict1):
        self.user = dict1
        self.id = dict1['email']
        self.__passw = dict1['Password']
        self.lg_status = False
 
    def login(self):
        id = input("Enter mobile no: ")
        if id.isdigit():
            id = int(id)
        else:
            id = str(id)
        passw = input("Enter password:")
        if id == self.id or id == self.email:
            if passw == self.__passw:
                print("Successfully login...")
                self.lg_status = True
            else:
                print("wrong password")
        else:
            print("wrong username")
 
   
    def bookTicket(self,to,froml):
        try:
            if self.lg_status:
                print(f"ticket confirmed from {str(froml).title} to {str(to).title}  ")
            else:
                raise Exception("not loggedin")
        except:
            print(sys.exc_info())
