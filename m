From: yukta eswar <yukta.eswar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about invoking of "Task management" functions in USB driver
	(from newbie)
Date: Tue, 29 Sep 2009 19:51:47 +0530
Message-ID: <ac9fc6790909290721y6b046793rd28357595be2f3a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Dear Experts,

I am developing a new USB attached SCSI (UAS) driver for Linux.
I have implemented "task management" functions by taking reference
from SAS driver.
But I am confused about how to invoke these functions from my application.

Do I need to make any specific function calls from my application to
invoke these driver functions?
Can I get any reference code which can invoke Task management functions ?

Thanks in advance,

Regards,
Yukta
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
