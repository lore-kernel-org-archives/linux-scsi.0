From: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Thu, 4 Oct 2007 12:48:58 +0200
Message-ID: <20071004104858.GF10852@stusta.de>
References: <20071003090058R.fujita.tomonori@lab.ntt.co.jp> <0631C836DBF79F42B5A60C8C8D4E8229CC39C7@NAMAIL2.ad.lsil.com> <20071004084651L.fujita.tomonori@lab.ntt.co.jp> <20071004072834.GD5236@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33906 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755796AbXJDKsd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 06:48:33 -0400
Content-Disposition: inline
In-Reply-To: <20071004072834.GD5236@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Sumant.Patro@lsi.com, James.Bottomley@SteelEye.com, bwindle@fint.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Thu, Oct 04, 2007 at 09:28:34AM +0200, Jens Axboe wrote:
>...
> Tomo, this is the patch I added.

Please excuse my comment in case this was already clear:

You are aware that this bug is a regression in 2.6.23-rc and the patch 
should therefore go to Linus ASAP and not after the release of 2.6.23?

> Jens Axboe

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

