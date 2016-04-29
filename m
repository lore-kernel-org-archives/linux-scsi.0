From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] hpsa driver updates
Date: Fri, 29 Apr 2016 19:11:19 -0400
Message-ID: <yq1lh3w9fjc.fsf@sermon.lab.mkp.net>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbcD2XMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 19:12:03 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda> (Don
	Brace's message of "Wed, 27 Apr 2016 17:13:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> These patches are based on Linus's tree The changes are: - move
Don> call to scsi_scan_host below where interrupts are enabled - add in
Don> timouts for driver initiated commands.  - some faulty disks caused
Don> initialization hangs.  - correct ioaccel change events - correct
Don> ioaccel error checking - enhance hot-plug operations for HBA mode -
Don> add a sysfs attribute for sas addresses - bump driver version

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
