From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 20:25:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629182546.GB15024@win.tue.nl>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kweetal.tue.nl ([131.155.3.6]:30226 "EHLO kweetal.tue.nl")
	by vger.kernel.org with ESMTP id S265721AbTF2SL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:11:29 -0400
Content-Disposition: inline
In-Reply-To: <3EFF28AC.104@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 29, 2003 at 01:58:04PM -0400, Jeff Garzik wrote:

> I would still prefer to detect "MMC", at least in ATAPI's case, and then 
> use that flag to trickle down knowledge to use_10_for_ms and similar 
> features.  ATAPI is even easier than I was previously thinking:  at 
> host-alloc time, we already know the devices will be MMC, and never ever 
> want 6-byte commands.

And what do they want? 12-byte commands?
What standard are you reading? SFF-8020? ATA-4?

Andries

