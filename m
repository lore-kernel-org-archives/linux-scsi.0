From: =?iso-8859-1?q?Liong=20Hoong?= <liongshliongsh@yahoo.com>
Subject: Re: sg_io_hrd_t - host_status error (0x05)
Date: Tue, 27 Apr 2004 11:43:08 +0800 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427034308.89924.qmail@web40004.mail.yahoo.com>
References: <4089E368.5040002@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web40004.mail.yahoo.com ([66.218.78.22]:33363 "HELO
	web40004.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263731AbUD0DnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 23:43:09 -0400
In-Reply-To: <4089E368.5040002@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hi Douglas Gilbert,

Thanks for commenting on the problem I am facing. I
have few other question,

1) Is it a common error on kernel 2.4.18 where the
host_status error, SG_ERR_DID_ABORT occured whenever
pass through opcodes from 0x80 to 0x9f?

2) Is there any patch to work around this error?

3) Can you point me to any links or codes that have
caused the error?

Thanks for spending time on my doubts.

Best Regards,
Sean

--- Douglas Gilbert <dougg@torque.net> wrote: > Liong
Hoong wrote:
> > Hi all,
> > 
> > I have set up the main control structure for the
> > version 3 SCSI generic driver. I am trying to send
> > down some opcodes (vendor specific) to a usb mass
> > storage device. Found that I encountered
> host_status
> > error, SG_ERR_DID_ABORT whenever I send opcodes
> from
> > 0x80 to 0x9f, but encountered no errors with other
> > opcodes. 
> > 
> > The errors occured even without the device plugged
> in,
> > which seem the sg driver has exclusively blocked
> the
> > opcodes from 0x80 to 0x9f. Is it true?? Is there
> any
> > work around for this??
> > 
> > Is it because of Group 4 (0x80 to 0x9f) need 16
> bytes
> > of cdb length? But even I prepare the cdb of 16
> bytes,
> > it also failed. 
> > 
> > I am using red hat 8.0, 2.4.18. 
> 
> The scsi subsystem mid level allowed 16 byte cdbs
> through
> from and including lk 2.4.15 . The sg driver allows
> them
> through. That leaves the usb-storage driver (and
> drivers
> further down the USB stack) and the device itself as
> the
> cause of your problem.
> 
> Doug Gilbert
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html 

__________________________________________________
Do You Yahoo!?
Log on to Messenger with your mobile phone!
http://sg.messenger.yahoo.com
