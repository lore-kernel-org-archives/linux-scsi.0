From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Fri, 11 Mar 2016 07:37:06 -0500
Message-ID: <yq1bn6lkx71.fsf@sermon.lab.mkp.net>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
	<CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcCKMhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 07:37:15 -0500
In-Reply-To: <CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
	(Tom Yan's message of "Fri, 11 Mar 2016 11:53:51 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> In that case, if the granularity only act as some sort of
Tom> "reference" but has no real "binding" to the actual behaviour, why
Tom> would the kernel even "make up" the granularity itself according to
Tom> the physical block size of the device:

Tom> q-> limits.discard_granularity = max(sdkp->physical_block_size,
Tom>     sdkp-> unmap_granularity * logical_block_size);

Many devices predate the UNMAP-related fields in the Block Limits
VPD. There are also devices that do not report an OPTIMAL UNMAP
GRANULARITY despite supporting UNMAP.

-- 
Martin K. Petersen	Oracle Linux Engineering
