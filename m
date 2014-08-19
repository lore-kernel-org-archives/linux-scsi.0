From: "Sharma, Sanjeev" <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Tue, 19 Aug 2014 09:38:41 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2FE70@EU-MBX-02.mgc.mentorg.com>
References: <yes>
 <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
 <53E9B418.3050303@redhat.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
 <20140819093047.GA991@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140819093047.GA991-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org" <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Thanks for letting me know.

Sanjeev Sharma

-----Original Message-----
From: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org] 
Sent: Tuesday, August 19, 2014 3:01 PM
To: Sharma, Sanjeev
Cc: kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org; linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hans de Goede
Subject: Re: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

On Tue, Aug 19, 2014 at 06:33:04AM +0000, Sharma, Sanjeev wrote:
> Hi Greg,
> 
> Any feedback on this patch ?

The merge window ended 2 days ago, _and_ I'm at the kernel summit this week, _and_ my queue is currently sitting at:
	$ mdfrm -c ~/mail/todo/
	1317 messages in /home/gregkh/mail/todo/

So please be patient.  I'll get to it in a few weeks.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
