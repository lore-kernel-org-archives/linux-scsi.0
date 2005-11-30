From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Wed, 30 Nov 2005 08:46:35 -0600
Message-ID: <1133361995.3312.0.camel@mulgrave>
References: <20051129200334.GB15804@suse.de>
	 <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org>
	 <20051130080854.GD15804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24723 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751225AbVK3Oq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 09:46:58 -0500
In-Reply-To: <20051130080854.GD15804@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-11-30 at 09:08 +0100, Jens Axboe wrote:
> Oh well, so much for expecting than even the most basic SCSI behaviour
> is always implemented correctly. A device must only return
> 0x05/0x20/0x00 for an illegal opcode. It's a little suspicious I'd say,
> are you sure it isn't something else affecting this? Even though there
> are crappy devices out there, this seems a little too odd to me.

And anyway, just because it doesn't actually work in the failing case
doesn't mean this isn't a good patch ... it's certainly unsafe to switch
back to 6 byte commands without checking for the correct illegal opcode
sense, so we should put it in anyway.

James


