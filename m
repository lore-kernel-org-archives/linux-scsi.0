From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 12:35:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC5135F.50803@pobox.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38602 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264480AbTEPQXM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:23:12 -0400
In-Reply-To: <20030516060324.GT812@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@suse.de>

Jens Axboe wrote:
> On Thu, May 15 2003, Jeff Garzik wrote:
> 
>>In terms of a userspace interface for my ata-over-scsi gadget, I would
>>prefer to use /dev/sg instead of inventing a totally new interface.
>>That, in turn, implies a need for a "do ata taskfile" scsi command,
>>which is sorta like ATAPI in reverse:  we are wrapping a raw ata
>>taskfile inside a scsi cdb.


Based on private responses as well as Jens' response, I think my initial 
post must have been terribly unclear.  Let me restate:

I have chosen the standard, existing scsi-generic nterface as the one by 
which raw taskfiles will be sent to devices.  The taskfile will be 
wrapped inside a SCSI cdb.  To me this solution is the most flexibility 
for least cost.

So, what opcode do I choose for "send taskfile"?  Either (a) pick a 
vendor-specific one, or (b) someone else already chose an opcode.

So my post was really these questions:  a or b?  if b, what opcode?

(see, existing interfaces satisfy my needs :))

	Jeff



