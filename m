From: Jens Axboe <axboe@suse.de>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 18:40:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516164003.GI812@suse.de>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC5135F.50803@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:44965 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264488AbTEPQ1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:27:09 -0400
Content-Disposition: inline
In-Reply-To: <3EC5135F.50803@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 16 2003, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Thu, May 15 2003, Jeff Garzik wrote:
> >
> >>In terms of a userspace interface for my ata-over-scsi gadget, I would
> >>prefer to use /dev/sg instead of inventing a totally new interface.
> >>That, in turn, implies a need for a "do ata taskfile" scsi command,
> >>which is sorta like ATAPI in reverse:  we are wrapping a raw ata
> >>taskfile inside a scsi cdb.
> 
> 
> Based on private responses as well as Jens' response, I think my initial 
> post must have been terribly unclear.  Let me restate:
> 
> I have chosen the standard, existing scsi-generic nterface as the one by 
> which raw taskfiles will be sent to devices.  The taskfile will be 
> wrapped inside a SCSI cdb.  To me this solution is the most flexibility 
> for least cost.

Aha, and how do you wrap an ata command nicely into a scsi cdb? I can
only see it getting ugly.

> So, what opcode do I choose for "send taskfile"?  Either (a) pick a 
> vendor-specific one, or (b) someone else already chose an opcode.
> 
> So my post was really these questions:  a or b?  if b, what opcode?

Irk! I can't believe you are suggesting something like this. Jeff,
please do yourself a favor and think about what you are saying for a
second.

> (see, existing interfaces satisfy my needs :))

I can transport maneur on the back seat of my car if I needed to,
doesn't necessarily make it a brilliant idea just because it's doable.

-- 
Jens Axboe

