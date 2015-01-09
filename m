From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] target: Don't arbitrary limit I/O size to fabric_max_sectors
Date: Fri, 09 Jan 2015 15:43:44 -0500
Message-ID: <yq17fwv1y7z.fsf@sermon.lab.mkp.net>
References: <1420590258-21122-1-git-send-email-nab@daterainc.com>
	<1420647107.12144.8.camel@haakon3.risingtidesystems.com>
	<yq1zj9t2v9t.fsf@sermon.lab.mkp.net>
	<1420757368.2842.33.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420757368.2842.33.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Thu, 08 Jan 2015 14:49:28 -0800")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> The concern is when older hardware drivers are reporting say
nab> queue_max_hw_sectors=128 with initiators are not actively honoring
nab> block limits EVPD MAXIMUM TRANSFER LENGTH, that would result in
nab> I/Os over 64K generating exception status.

Given that you're already splitting I/Os in IBLOCK I think it would
probably be better to pick a size you're comfortable with. 4 or 8 megs
sound reasonable to be

-- 
Martin K. Petersen	Oracle Linux Engineering
