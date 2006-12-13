From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Wed, 13 Dec 2006 10:06:37 +0200
Message-ID: <457FB48D.4050206@panasas.com>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com> <457F2F17.3000009@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:46193 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932616AbWLMIdJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 03:33:09 -0500
In-Reply-To: <457F2F17.3000009@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Riffard <laurent.riffard@free.fr>, linux-scsi@vger.kernel.org

Laurent Riffard wrote:
> 
> Christoph's patch fixed the BUG, while Boaz's patch didn't fix anything 
> (both tested with kernel 2.6.16-rc6-mm2). 
> 
> Please note I don't use ide-cd, I use libata+pata_via+sr_mod.
> 
> Boaz, when you wrote "below patch combined with your patch...", did you mean 
> your patch should be applied on top of Christoph's one ? In this case, it fails with:
>    patching file drivers/block/pktcdvd.c
>    Hunk #1 FAILED at 778.
>    1 out of 1 hunk FAILED -- rejects in file drivers/block/pktcdvd.c
> 

Disregard my patch, it was only to point out places that are broken.
Just that I was working at exact same problems and it was something in my Q.

Free Life
Boaz
