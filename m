From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 15:00:00 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
	<20080724101953R.fujita.tomonori@lab.ntt.co.jp>
	<20080724133012.GH8833@beardog.cca.cpqcorp.net>
 <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5770 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYGXPAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:00:51 -0400
In-Reply-To: <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> > As for the patches I mentioned which were previously ignored for
> > improving how the current cciss SCSI code handled hot plogging, if
> > you're curious about that, check here:
> >
> > http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> >
> > A change like that becomes more important if logical drives are
> > exposed through the scsi layer.
>
> We need to think about the best way to map (expose) logical
> and physical drivers to SCSI luns. As I wrote before, I'm
> interested in how HP SCSI driver does.

We don't neccesarily want or need to expose the physical disks. The only exception is disks that are not part of a logical volume. If the disks are part of a logical volume but exposed the user may shoot themselves in the foot by destroying the firmware metadata.

-- mikem
