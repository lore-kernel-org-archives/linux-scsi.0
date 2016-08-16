From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Tue, 16 Aug 2016 00:15:15 -0400
Message-ID: <yq18tvxl57w.fsf@sermon.lab.mkp.net>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
	<yq1r39upy7p.fsf@sermon.lab.mkp.net>
	<CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
	<yq1lh01n1ul.fsf@sermon.lab.mkp.net>
	<CAGnHSEnycyCRy=SHXs+fQx8mwaQwLtAKO1thH6yYscbBkL2+VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42783 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcHPEP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2016 00:15:27 -0400
In-Reply-To: <CAGnHSEnycyCRy=SHXs+fQx8mwaQwLtAKO1thH6yYscbBkL2+VQ@mail.gmail.com>
	(Tom Yan's message of "Sun, 14 Aug 2016 17:23:45 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> The thing is, as of ACS-4, blocks that carry DSM/TRIM LBA Range
Tom> Entries are always 512-byte.

Lovely. And SAT conveniently ignores this entirely.

Tom> Honestly, I have no idea how that would work on a 4Kn SSD, if it is
Tom> / will ever be a thing.

Highly unlikely.

But I guess you would have to report 8 512-byte ranges in the 4Kn
case. And then rely on the patch we talked about to clamp the number of
sectors based on the block layer limit.

-- 
Martin K. Petersen	Oracle Linux Engineering
