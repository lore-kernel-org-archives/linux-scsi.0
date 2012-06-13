From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Wed, 13 Jun 2012 10:27:55 +0900
Message-ID: <CAKYAXd-9VXpNwUSnsgrDbXAwzSPnBnep6kWGZhbzB623LF0grw@mail.gmail.com>
References: <1339511190-2440-1-git-send-email-linkinjeon@gmail.com>
	<20120613011114.GF6765@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120613011114.GF6765-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

2012/6/13, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>:
> On Tue, Jun 12, 2012 at 10:26:30AM -0400, Namjae Jeon wrote:
>> Update information of Seagate Portable HDD and WD My Passport HDD in
>> quirk list.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>
Dear Greg.
> What happened to the 2 other patches in this series?
The reason is that I tried to send patch again after making the
mistake(Patch number).
I will resend the patches after arranging.
>
> And why is your From: email address different from your Signed-off-by:
> address?  If you are emailing from a different email account than your
> "real" one, please put a "From: My name <email_address>" as the first
> line in the body of the text for the patch, so git will get things
> correct (see the file, Documentation/SubmittingPatches for details about
> this.)
>
> So, care to resend these so I can apply them?
Yes, sure, I will resend the patches after changing.
Thanks.
>
> thanks,
>
> greg k-h
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
