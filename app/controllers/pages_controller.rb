require 'sinatra'
require 'intercom'
require 'dotenv'
require 'httparty'



Dotenv.load
class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

    def index
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      @pages = Page.all()
      @contacts = intercom.contacts.all
      @articles = intercom.articles.all
      @attributes = intercom.data_attributes.all
      @teams = intercom.teams.all
      @counts = intercom.counts.for_app
      @admins = intercom.admins.all
      @conversations = intercom.conversations.search(
        query: {
          field: "open",
          operator: "=",
          value: true
        },
        sort_field: "created_at",
        sort_order: "descending"
      )
    end

    def show
        @page = Page.find(params[:id])
    end

    def delete
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      intercom.contacts.delete(intercom.contacts.find(id: (params[:id])))
    end

    def deleteArticle
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      intercom.articles.delete(intercom.articles.find(id: (params[:id])))
    end

    def update
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      @article = intercom.articles.find(id: (params[:id]))
    end

    def updatec
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      @contact = intercom.contacts.find(id: (params[:id]))
    end

    def updatearticle1
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      @article = intercom.articles.find(id: (params[:id]))
      @article.title = params[:title]
      @article.description = params[:description]
      intercom.articles.save(@article)
    end

    def updateuser
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      @contact = intercom.contacts.find(id: (params[:id]))
      @contact.name = params[:name]
      @contact.email = params[:email]
      intercom.contacts.save(@contact)
    end

    def reports
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
    end
    
    def new
      @page = Page.new
    end

    #CREATE NEW ARTICLE.
    # TODO: ADMIN_ID IS HARD CODED RIGHT NOW.
    def article
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      article = intercom.articles.create(title: params[:title], description: params[:description], author_id: "5177844")
    end
     
    # CREATE NEW EMAIL.
    # ADMIN AND USER ARE HARD CODED RIGHT NOW.
    def email
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      intercom.messages.create({
        message_type: 'email',
        subject: 'Hey there',
        body: "What's up :)",
        template: "plain", # or "personal",
        from: {
          type: "admin",
          id: "1234"
        },
        to: {
          type: "user",
          id: "536e564f316c83104c000020"
        }
      })
    end

    #CREATE NEW LEAD WITH USER NOTE, TAG, AND START NEW CONVO.
    #TODO: CHECK IF THE LEAD EXISTS, IF IT DOES UPDATE INSTEAD OF CREATE NEW.
    def create
      #API key
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      #look for contact with email from form
      @contacts = intercom.contacts.find(email: params[:email])
      #if contacts is empty should go here
      #CREATE NEW CONTACT
      contact = intercom.contacts.create(:email => params[:email], role: "lead")  
      #create note attached to lead
      contact.create_note(body: "<p>Text for the note</p>" + (params[:note].to_s))
      #add tag
      contact.add_tag(id: params[:tagName2], admin_id: params[:adminID])
      #create message with new contact
      intercom.messages.create({
        from: {
          type: "contact",
          id: contact.id,
          email: params[:email]
        },
        body: ("This is a message from the contact form:" + (params[:message].to_s))
      })
      redirect_to new
      #ELSE UPDATE LEAD SHOULD GO HERE
    end

    #TODO CREATE NEW ATTRIBUTE
    def attribute
      intercom = Intercom::Client.new(token: 'dG9rOmMwMzU0Y2ZiXzI1MDdfNDVmOV84Njc5XzJmYmMzNDZiYzc5YToxOjA=')
      data = intercom.data_attributes.create({ name: params[:attName], model: "contact", data_type: params[:dataType] })
    end
  end

