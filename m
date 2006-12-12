From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] remove the broken SCSI_SEAGATE driver
Date: Tue, 12 Dec 2006 17:31:14 -0600
Message-ID: <1165966274.5903.56.camel@mulgrave.il.steeleye.com>
References: <20061212162238.GR28443@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38174 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932541AbWLLXh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 18:37:29 -0500
In-Reply-To: <20061212162238.GR28443@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2006-12-12 at 17:22 +0100, Adrian Bunk wrote:
> The SCSI_SEAGATE driver has:
> - already been marked as BROKEN in 2.6.0 three years ago and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.

Would you care to explain the rationale for this, please.  If the driver
had been riddled with errors and compilation problems, I might have
acquiesced, but now I come to look it over, it seems structurally
reasonably OK (we certainly have non-BROKEN worse ones) plus it compiles
fine.  So I'm wondering why it's marked broken in the first place.

Since it was your original patch:

Author: Adrian Bunk <bunk@fs.tum.de>
Date:   Mon Sep 1 19:22:52 2003 -0700

    [PATCH] Mark more drivers BROKEN{,ON_SMP}
    
    - let more drivers that don't compile depend on BROKEN
    - MTD_BLKMTD is fixed, remove the dependency on BROKEN
    - let all drivers that don't compile on SMP (due to cli/sti usage)
      depend on a BROKEN_ON_SMP that is only defined if !SMP || BROKEN
    - #include interrupt.h for dummy cli/sti/... in two files to fix the
      UP compilation of these files
    
    I marked only drivers that are broken for a long time and where I don't
    know about existing fixes with BROKEN or BROKEN_ON_SMP.

I'd like to know why it was marked BROKEN in the first place.

Thanks,

James


