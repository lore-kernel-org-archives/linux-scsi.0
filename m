From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 14:32:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFF30CB.2050301@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com> <20030629182546.GB15024@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47762 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265714AbTF2SSh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:18:37 -0400
In-Reply-To: <20030629182546.GB15024@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> On Sun, Jun 29, 2003 at 01:58:04PM -0400, Jeff Garzik wrote:
> 
> 
>>I would still prefer to detect "MMC", at least in ATAPI's case, and then 
>>use that flag to trickle down knowledge to use_10_for_ms and similar 
>>features.  ATAPI is even easier than I was previously thinking:  at 
>>host-alloc time, we already know the devices will be MMC, and never ever 
>>want 6-byte commands.
> 
> 
> And what do they want? 12-byte commands?
> What standard are you reading? SFF-8020? ATA-4?

MMC-<1234> from t10.org, which if considered over time (i.e. changes 
from 1 -> 2 -> 3 -> 4 are interesting) gives a fairly reasonable picture 
of the subset of scsi that atapi belongs to.  That picture seems to gibe 
with the atapi testing on ancient devices I've done so far.  MMC sorta 
takes over where SFF left off, IMO.  You definitely want the sff docs 
too for the full picture (as you no doubt know already).

	Jeff



