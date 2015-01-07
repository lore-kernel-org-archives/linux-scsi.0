From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/8] megaraid_sas : Endianness related bug fixes and code optimization
Date: Tue, 06 Jan 2015 19:24:16 -0500
Message-ID: <yq1k30z780f.fsf@sermon.lab.mkp.net>
References: <201501051440.t05Ee0Ld029960@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201501051440.t05Ee0Ld029960@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:05:58 +0530")
Sender: stable-owner@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> This patch addresses below issues- 1) Few endianness bug fixes.
Sumit> 2) Break the iteration after (MAX_LOGICAL_DRIVES_EXT - 1)),
Sumit> instead of MAX_LOGICAL_DRIVES_EXT.  3) Optimization in MFI INIT
Sumit> frame before firing.  4) MFI IO frame should be 256bytes
Sumit> aligned. Code is optimized to reduce the size of frame for fusion
Sumit> adapters and make the MFI frame size calculation a bit
Sumit> transparent and readable.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
