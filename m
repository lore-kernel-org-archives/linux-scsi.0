From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Fri, 11 Mar 2016 16:41:54 -0500
Message-ID: <yq1vb4sk7z1.fsf@sermon.lab.mkp.net>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
	<CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
	<yq1bn6lkx71.fsf@sermon.lab.mkp.net>
	<CAGnHSEn-5=nzryFJ6wZU+f82kHqf6LJLfi6LbWCyq+qd+E1TWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbcCKVmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 16:42:01 -0500
In-Reply-To: <CAGnHSEn-5=nzryFJ6wZU+f82kHqf6LJLfi6LbWCyq+qd+E1TWQ@mail.gmail.com>
	(Tom Yan's message of "Fri, 11 Mar 2016 22:55:30 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> Would min_not_zero() be more proper than max()?

That would effectively set discard_granularity to physical_block_size
regardless of whether unmap_granularity was provided or not.

-- 
Martin K. Petersen	Oracle Linux Engineering
