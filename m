From: Luben Tuikov <tluben@rogers.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 15:02:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC535D9.10504@rogers.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC5135F.50803@pobox.com> <20030516183732.GA102@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:41615
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S264589AbTEPSuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2003 14:50:03 -0400
In-Reply-To: <20030516183732.GA102@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Andries Brouwer wrote:
> On Fri, May 16, 2003 at 12:35:43PM -0400, Jeff Garzik wrote:
> 
> 
>>I have chosen the standard, existing scsi-generic nterface as the one by 
>>which raw taskfiles will be sent to devices.  The taskfile will be 
>>wrapped inside a SCSI cdb.  To me this solution is the most flexibility 
>>for least cost.
>>
>>So, what opcode do I choose for "send taskfile"?  Either (a) pick a 
>>vendor-specific one, or (b) someone else already chose an opcode.
>>
>>So my post was really these questions:  a or b?  if b, what opcode?
> 
> 
> 0xAA ?
> 
> (have you seen rfc2143 ?)

This is for a communications device, which according to the
spec is obsolete, but most importantly it's not a block device
opcode.

But the idea isn't new -- AFAIR, the 3ware LLDD/userspace tools
use(d) 0x80 XDWRITE EXTENDED (16) which is _optional_ for block devices.
For what pupose, it's closed, but it will have something to do with
the hdwr array management/id.

-- 
Luben





