# Introduction

Remember the last time that you bought an airline ticket?  You got an email with a "record locator".
When you checked in for your flight, the airline didn't make you enter "23873498712098234095723469"
to get your boarding pass.  You entered something like "FK92B9", and your name.  The airline used
your name and that code to find the ID.

It's about usability.  If humans ever need to type Active Record database IDs into a form for some
reason, then don't make them type a huge number, give them a short code.  (An argument can be made
that if humans ever need to type record IDs into forms then you have bigger UX problems than the
record ID format, and this is very true.)

One way to provide an easier ID to type is to use Base 36.  It takes an integer and returns a really
short string that you can convert back to that integer again.  And it's really easy to use with
Ruby:

    12345678901.to_s(36).upcase
    => "5O6AQT1"

    "5O6AQT1".to_i(36)
    => 12345678901

The problem with "5O6AQT1" is the second character.  Is that an "O" or a "0"?  And that last
character, is that a "1" or an "I"?  And "Q" is a land mine too.  It can look a lot like an "O" or
"0".

What we really need is Base 31.  We want to use Base 36, but without the potentially confusing
characters.  That's the Record Locator gem.  I needed this gem and it didn't exist, so I
commissioned the impeccable services of Mr. Abdul Barek in Bangladesh, who did a fantastic job.

# How to install

Include the gem into your Gemfile:

    gem 'record_locator', '1.0.0', :git => 'git@github.com:VenueDriver/record_locator.git'

Then run

    bundle install

Suppose, you want to apply this encoding stuff on your Book Model's publisher_id then follow this way:

    class Book < ActiveRecord::Base
      extend RecordLocator
      has_record_locator :publisher_id
    end

**Now restart your server!**

**has_record_locator will expect Numeric field only (here publisher_id is Integer)**

From your ActiveRecord model object, You can get the encoded value by calling encoded_record_locator method:

    @book.encoded_record_locator

You can find the ActiveRecord Model Object by passing encoded value, for example:

    Blog.record_locator.find(params[:encoded_publisher_id])
