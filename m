From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: on-off periodic hangs in scsi commands
Date: Thu, 06 Jan 2011 22:25:51 +0300
Message-ID: <4D26173F.4030506@vlnb.net>
References: <4D24BEC4.7040906@shiftmail.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCM7U1pyGBxCFrpjpBBoEXIyCHA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4D24BEC4.7040906-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Spelic <spelic-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Spelic, on 01/05/2011 09:56 PM wrote:
> I am cc-ing the open-iscsi and scst people to see if they can suggest a 
> way to debug the iscsi one. In particular it would be very interesting 
> to get the number of commands received and replied from target side, and 
> match it to the number of commands submitted from initiator side. (but I 
> suspect these status variables do not exist) If target side says it has 
> already replied, but initiator side sees the reply after 1 second... 
> that would be very meaningful. The bad thing is that I do not have much 
> time to debug this :-(

For SCST you can enable "scsi" logging. Then you will see all the coming
SCSI commands and responses for them in the kernel log. To deal with the
large volume of logs this facility can produce, you will need to switch
your logging application (syslogd?) into async mode (no fsync after each
logged line).

Vlad

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
