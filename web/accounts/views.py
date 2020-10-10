from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.models import User, auth
# Create your views here.

def register(request):
    if request.method == "POST":
        firstname = request.POST['firstname']
        lastname = request.POST['lastname']
        email = request.POST['email']
        password = request.POST['password']
        if User.objects.filter(username=email).exists():
            return HttpResponse('user is already taken')
        else:
            user = User.objects.create_user(username=email, email=email, password=password, first_name=firstname, last_name=lastname)
            user.save()
            return HttpResponse('user created')

    else:
        return render(request, 'register.html')