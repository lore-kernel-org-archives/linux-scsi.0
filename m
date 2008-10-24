From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Fri, 24 Oct 2008 15:10:57 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16131 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYJXPLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 11:11:41 -0400
In-Reply-To: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Lawler, Tom" <Tom.Lawler@hp.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Jens.Axboe@oracle.com" <Jens.Axboe@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Tomo wrote:

>
> My scsi driver is still in an early stage (I tried to keep
> the changes minimum). I can detect logical units, mount a
> file system, do lots of I/Os, however, there are lots of
> TODOs in the management features.
>
> If I can get an ACK from HP about the long-term migration of
> cciss to SCSI, I'm happy to keep working on the SCSI cciss
> driver and maintain it until HP takes over the driver.

Just a brief update. HP has developed a scsi version of cciss. It was originally done for another environment but we have decided to use it as the base for Linux. It was authored by Tom Lawler of HP. We are currently in the process of getting the Open Source Review Board approval to release the code to the community.

It's unclear right now as to who will be the maintainer.

-- mikem

>
>
> The patch is available at:
>
> http://www.kernel.org/pub/linux/kernel/people/tomo/ciss/0001-a
> dd-HP-Compaq-Smart-Array-5xxx-controller-SCSI-dri.patch
>
> clover:/home/fujita# insmod ciss.ko
> clover:/home/fujita# lsscsi
> (snip)
> [1:0:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde
> [1:0:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf
> [1:0:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg
> [1:0:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh
>
> Yeah, it just works as SCSI disk, the dmesg says:
>
> sd 1:0:0:0: [sde] Attached SCSI disk
> sd 1:0:0:1: [sdf] 143305920 512-byte hardware sectors (73373
> MB) sd 1:0:0:1: [sdf] Write Protect is off sd 1:0:0:1: [sdf]
> Mode Sense: 5b 00 00 08 sd 1:0:0:1: [sdf] Write cache:
> disabled, read cache: enabled, doesn't support DPO or FUA
>
> I needed a different name and just stole 'ciss' from *BSD.
> But any names (like hpciss) works for me.
>
>
> Thanks,
>
