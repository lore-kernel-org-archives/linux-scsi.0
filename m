From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Tue, 27 Jan 2004 18:56:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401627C3.20101@torque.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com> <1075136727.2290.48.camel@mulgrave> <20040126193413.A3302@infradead.org> <20040127061800.GB429536@sgi.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:53521 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263002AbUA0JAY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 04:00:24 -0500
In-Reply-To: <20040127061800.GB429536@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeremy Higdon wrote:
> On Mon, Jan 26, 2004 at 07:34:13PM +0000, Christoph Hellwig wrote:
> 
>>On Mon, Jan 26, 2004 at 11:05:26AM -0600, James Bottomley wrote:
>>
>>>>I had avoided it due the comments in the code
>>>>from sralston and pdelaney about sg interface 
>>>>gererating wrong direction in some cases.  
>>>
>>>If you find a problem, I'll fix the generic code...
>>
>>I think it's just very old comments.  We had such a problem in early 2.4
>>kernels, but it has been fixed for ages.  If it wasn't most of the scsi
>>drivers would have a big problem.
> 
> 
> Aren't there three interfaces for sg, or did the early ones go away
> in 2.6?  I recall that we ran into trouble with sg setting the
> direction incorrectly in 2.4 kernels when using older interface,
> I think.

Jeremy,
I can't see any such report in my changelogs for the sg
driver during the lk 2.4 series. What was difficult with
the older sg interface (sg_header based) was setting the
command length as this was "guessed" from the first 3 bits
of the opcode (SCSI_IOCTL_SEND_COMMAND ioctl still does this).

Doug Gilbert


