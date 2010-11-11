From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 11:50:19 -0800
Message-ID: <E61DA540-D3C6-472F-8680-DA57ECBEC76A@yahoo.com>
References: <20101111174322.GB20296@one-eyed-alien.net> <673670.8195.qm@web31801.mail.mud.yahoo.com> <20101111184946.GC20296@one-eyed-alien.net> <20101111191110.GA12308@kroah.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101111191110.GA12308-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Nov 11, 2010, at 11:11, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Nov 11, 2010 at 10:49:46AM -0800, Matthew Dharm wrote:
>> On Thu, Nov 11, 2010 at 10:27:11AM -0800, Luben Tuikov wrote:
>>> The patch uses SCSI functions to abstract the sense information irrespective of the type of format of sense data.
>> 
>> Looks reasonable.  The underlying SCSI functions seem to all have the tests
>> to distinguish between sense format types.  Let's just hope there are no
>> devices out there which can confuse those tests, or we'll be buried in
>> regressions.
>> 
>> ACKed-by: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
> 
> Luben, can you resend me the original patch with Matthew's ack on it?  I
> no longer have it in my mboxes.
> 

No prob. 

> thanks,
> 
> greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
