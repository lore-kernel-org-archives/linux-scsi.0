From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/22] lpfc 8.1.2 driver update, crash in lpfc_worker_0
Date: Sun, 12 Feb 2006 09:20:15 -0600
Message-ID: <1139757616.3808.4.camel@mulgrave.il.steeleye.com>
References: <43EA10FC.3030008@emulex.com>  <20060212145736.GA23765@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48545 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750792AbWBLPU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 10:20:28 -0500
In-Reply-To: <20060212145736.GA23765@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-02-12 at 15:57 +0100, Olaf Hering wrote:
> Decbpuug: 0x3 :s Velecteorpi: 30n0 (gD afutanc Atcicesos)n  acat l[cl0e00d 00fr00o3fm bib2envba0]
> id   c o pnct: ecx0t0 a00t0 i00n00c052lu22dce/: l.inreusxc/hpaedg_etmaaps.k+0hx:314/06xc08       l
> 
>     lr: c000000000053adc: .try_to_wake_up+0x4a8/0x51c
>     sp: c00000003fbb3130
>    msr: a000000000001032
>    dar: c00001800048acb0
>  dsisr: 40000000
>   current = 0xc0000000034d07f0
>   paca    = 0xc00000000048b280
>     pid   = 1167, comm = lpfc_worker_0

This is IBM pSeries, isn't it?  That crash is very characteristic of one
we at SteelEye have been trying to track down with the help of IBM ...
my suspicion is that there's a bug in the pSeries process handling code
which manifests around wake up under stress.

Could you try to produce this on a non-ppc machine?

Thanks,

James


