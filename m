From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Request for moving Sg_request into sg.h
Date: Tue, 08 Mar 2005 21:49:03 +1000
Message-ID: <422D912F.6020505@torque.net>
References: <422D771E.6070104@shadowconnect.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:63905 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262029AbVCHLsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2005 06:48:05 -0500
In-Reply-To: <422D771E.6070104@shadowconnect.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Markus Lidel wrote:
> Hello,
> 
> i wanted to ask if it is possible to put the typedef "Sg_request" into 
> sg.h?

A surprising question. I would have though Sg_request was
private to the sg driver but ...

It is possible. Seems as though "#if __KERNEL__" conditional
blocks are still acceptable in kernel headers and scsi/sg,h
already has such a block.

If Sg_request moved to sg.h then that would require Sg_scatter_hold
to move as well.

> The reason i'm asking is, i need to pass data through SG_IO from an 
> application to the driver. At the moment the problem is solved by 
> copying code of the SG_IO driver into i2o_config (the passthru 
> function). I'm working on removing the passthru function and instead 
> using the SG_IO interface, but therefore i need to pass some additional 
> data to the driver. I could use the use the "flags" and "usr_ptr" fields 
> in sg_io_hdr_t, but i need to get access to them through "Sg_request".
> 
> Any comments appreciated.

Let's see what the style police say :-)

Doug Gilbert
