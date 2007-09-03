From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] revert sg segment size ifdefs
Date: Mon, 3 Sep 2007 12:30:24 +0200
Message-ID: <20070903103024.GO4253@kernel.dk>
References: <20070903103501F.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12925 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXICKes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2007 06:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20070903103501F.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Mon, Sep 03 2007, FUJITA Tomonori wrote:
> The patchset is against Jens' sg chaining branch.
> 
> Jens removed old SCSI_MAX_PHYS_SEGMENTS hack and the maximum is always
> 128:
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=d6beb57f48231f5c012fb7d55b369bc0af6b0c41
> 
> I talked to James at linuxconf.eu and he likes to provide a way to
> reduce sgpool memory consumption because with libata everyone
> (including small machines) uses the mid layer.
> 
> This patch reverts sg segment size ifdefs that the current mid layer
> has. Later we might do something better like relating
> SCSI_MAX_SG_SEGMENTS with other config options like CONFIG_EMBEDDED or
> just having SCSI_MAX_SG_SEGMENTS in menuconfig.
> 
> Now we have sg chaining code in -mm. As discussed before, it would be
> nice to test sg chaining code in -mm with a small SCSI_MAX_SG_SEGMENTS
> value like 32.

I'd rather avoid this, but it's not a big deal. I'll add it.

-- 
Jens Axboe

