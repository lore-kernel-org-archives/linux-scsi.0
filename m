From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Thu, 11 Aug 2016 21:34:02 -0400
Message-ID: <yq1r39upy7p.fsf@sermon.lab.mkp.net>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
	(tom's message of "Thu, 11 Aug 2016 16:26:39 +0800")
Sender: linux-block-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: tj@kernel.org, shaun.tancheff@seagate.com, shaun@tancheff.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom," == tom ty89 <tom.ty89@gmail.com> writes:

Tom,

+		put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM /
+				   (sector_size / 512), &rbuf[36]);

MAXIMUM WRITE SAME LENGTH is in units of the device's logical block
size.

-- 
Martin K. Petersen	Oracle Linux Engineering
