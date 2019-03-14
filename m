From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: Fix performance issue(QD) on logical drives
Date: Thu, 14 Mar 2019 07:12:31 -0400
Message-ID: <yq1tvg5n200.fsf@oracle.com>
References: <1552030001-10658-1-git-send-email-sagar.biradar@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1552030001-10658-1-git-send-email-sagar.biradar@microchip.com>
        (sagar biradar's message of "Thu, 7 Mar 2019 23:26:41 -0800")
Sender: stable-owner@vger.kernel.org
To: sagar.biradar@microchip.com
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, aacraid@microsemi.com, dave.carroll@microchip.com, scott.benesh@microchip.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Sagar,

> From: Sagar Biradar <sagar.biradar@microchip.com>
>
> To: Martin K. Petersen <martin.petersen@oracle.com>
> To: James Bottomley <jejb@linux.vnet.ibm.com>
> cc: linux-scsi <linux-scsi@vger.kernel.org>
> cc: aacraid@microsemi.com
> cc: Dave Carroll <dave.carroll@microchip.com>
> cc: Scott Benesh <scott.benesh@microchip.com>
> cc: stable@vger.kernel.org
>
> Fix performance issue where the queue depth for SmartIOC logical
> volumes is set to 1, and allow the usual logical volume code
> to be executed

This wasn't a correctly formatted patch. Please see:

	Documentation/process/submitting-patches.rst

and remember to run checkpatch prior to submission.

I fixed it up. Applied to 5.1/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
