From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 20:37:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516183732.GA102@win.tue.nl>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC5135F.50803@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kweetal.tue.nl ([131.155.3.6]:25353 "EHLO kweetal.tue.nl")
	by vger.kernel.org with ESMTP id S264534AbTEPSYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 14:24:47 -0400
Content-Disposition: inline
In-Reply-To: <3EC5135F.50803@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Fri, May 16, 2003 at 12:35:43PM -0400, Jeff Garzik wrote:

> I have chosen the standard, existing scsi-generic nterface as the one by 
> which raw taskfiles will be sent to devices.  The taskfile will be 
> wrapped inside a SCSI cdb.  To me this solution is the most flexibility 
> for least cost.
> 
> So, what opcode do I choose for "send taskfile"?  Either (a) pick a 
> vendor-specific one, or (b) someone else already chose an opcode.
> 
> So my post was really these questions:  a or b?  if b, what opcode?

0xAA ?

(have you seen rfc2143 ?)


