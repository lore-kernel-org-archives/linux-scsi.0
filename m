From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Mon, 14 Mar 2016 16:07:19 -0400
Message-ID: <yq1egbcj020.fsf@sermon.lab.mkp.net>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
	<CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
	<yq1bn6lkx71.fsf@sermon.lab.mkp.net>
	<CAGnHSEn-5=nzryFJ6wZU+f82kHqf6LJLfi6LbWCyq+qd+E1TWQ@mail.gmail.com>
	<yq1vb4sk7z1.fsf@sermon.lab.mkp.net>
	<CAGnHSEkOpGGsecC8hL4Sbygrz1Cg+tR3EhZ7dOJcwp82+XgEDg@mail.gmail.com>
	<CAGnHSE=0qB2NyMxRu3Y+8VjJ-Ee7a3_O3qjprCEtfGg69dPnOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44839 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbcCNUH1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 16:07:27 -0400
In-Reply-To: <CAGnHSE=0qB2NyMxRu3Y+8VjJ-Ee7a3_O3qjprCEtfGg69dPnOg@mail.gmail.com>
	(Tom Yan's message of "Sat, 12 Mar 2016 13:43:02 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> But yeah if it has unmap granularity reported to be, for example,
Tom> 16, then it will not be correctly set with min_not_zero().

Tom> Wait, shouldn't it be:

Tom> max(sdkp->logical_block_size, sdkp->unmap_granularity * logical_block_size);

Tom> then?

Let's take the your example of a drive with 512-byte logical blocks and
4096-byte physical blocks. How would a drive partially unmap a sector?

-- 
Martin K. Petersen	Oracle Linux Engineering
