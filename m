From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Sat, 1 Jan 2011 16:34:14 -0700
Message-ID: <20110101233414.GA13577@parisc-linux.org>
References: <4D1F5A17.4010807@gmail.com> <20110101170854.GB32652@parisc-linux.org> <AANLkTikxhKXmnmCKr_HUW3dg3=O3qxNK+ThQEr37zEnC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41304 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1AAXeQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jan 2011 18:34:16 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikxhKXmnmCKr_HUW3dg3=O3qxNK+ThQEr37zEnC@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: roel kluin <roel.kluin@gmail.com>, nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Sat, Jan 01, 2011 at 06:28:34PM +0100, Torsten Kaiser wrote:
> <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ae52e7f09ff509df11cd408eabe90132b6be1231;hp=f034260db330bb3ffc815fcb682b1c84aca09591#patch2>
> -       if (pcmd->sc_data_direction == DMA_TO_DEVICE ) {
> +       if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0] | WRITE_10 ||
> pcmd->cmnd[0]|WRITE_12) {
> 
> Until June 2010 it was that way...

So it was.  Nick, why did you make this change?  Your commit message is
less than informative, partly because you're making such huge changes
in a single commit.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
