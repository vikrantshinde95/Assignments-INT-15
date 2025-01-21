import sys
import logging



class User():
    login_attempts = 0
    successful_logins = 0
 
    def __init__(self, **dict1):
        self.user = dict1
        self.id = dict1["Mobile No"]
        self.email = dict1["email"]
        self.__passw = dict1["Password"]
        self.lg_status = False
 
    def login(self):
        max_attempts = 3 
        for _ in range(max_attempts):
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

        User.login_attempts += 1 
        logging.info(f"User {self.id} attempted to log in. Total login attempts: {User.login_attempts}") 
        if self.lg_status: 
            logging.info(f"User {self.id} successfully logged in.") 
        else: 
            logging.error(f"User {self.id} failed to log in after {max_attempts} attempts.")
 
    # def bookTicket(self,source,destination):
    #     self.source = input("Enter your source: ")
    #     self.destination = input("Enter your destination: ")
    #     try:
            
    #         if self.source.isalpha() and self.destination.isalpha():
    #             print(
    #                 f"Ticket confirmed from {self.source.title()} to {self.destination.title()}"
    #                 )
    #         else:
    #             raise ValueError("Source and destination must be valid city names")
    #         # else:
    #         #     raise Exception("User not logged in")
    #     except Exception as e:
    #         print(e)


    def bookTicket(self,source,destination):
        cities = ["Pune", "Mumbai", "Delhi", "Chennai", "Bangalore"]
        self.source = input("Enter your source: ").title()
        self.destination = input("Enter your destination: ").title()
         
        if self.source in cities and self.destination in cities:
            print( f"Ticket confirmed from {self.source} to {self.destination}" )
        else: 
            raise ValueError("Source and destination must be valid city names")
        
        # except Exception as e: 
        #     print(e)
 
    # def bookTicket(self):
    #     self.source = input("Enter your source : ")
    #     self.destination = input("Enter your destination :")
    #     try:
    #         if self.source.isalpha():
    #             print(
    #                 f"ticket confirmed from {self.source.title()} to {self.destination.title()}  "
    #             )
    #         else:
    #             raise Exception("not loggedin")
    #     except:
    #         print(sys.exc_info())
    

    