From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 06 Jun 2003 19:27:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE12371.90403@rogers.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> <3EE0B316.4060207@rogers.com> <1054913984.1778.31.camel@mulgrave> <3EE0B8D8.4020909@rogers.com> <20030606215152.B3240@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:58668
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262358AbTFFXOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 19:14:12 -0400
In-Reply-To: <20030606215152.B3240@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Christoph Hellwig wrote:
> On Fri, Jun 06, 2003 at 11:52:56AM -0400, Luben Tuikov wrote:
> 
>>>Thus, we allow any special command because we assume it's part of error
>>>handling (or post error clean up).
>>
>>So SCSI Core _has_ decided to know about ULP (block, tape, optical).
>>
>>Unless we (SCSI Core) generate those, it's a pickle to decide
>>which are ``special'' enough commands.  I think that we'll see
>>more user space drivers controlling devices via sg sending
>>commands to the device for exactly those kinds of problems...
>>Else the burden on SCSI Core will/might be too great.
> 
> 
> I think James means REQ_SPECIAL request.  But some of them aren't
> special enough so we might need another flag for those.  But
> having knowledge about the upper drivers in the core sounds like
> a really bad idea.

*If* eh is to be done in SCSI Core you just cannot avoid it --
this is *the whole point* which James had in mind to allow
to send cmnds if !online. (see prev msgs on this thread)

(More things I want to mention here on this, but 1. No time
(I'm late for a meeting) and 2. I see no point -- you'll manage
just fine.)

-- 
Luben



