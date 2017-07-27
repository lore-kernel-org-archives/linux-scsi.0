From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: qedf: Limit number of CQs
Date: Wed, 26 Jul 2017 22:02:36 -0400
Message-ID: <yq160eey6v7.fsf@oracle.com>
References: <20170725092243.7E0CD50870B@solo.franken.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725092243.7E0CD50870B@solo.franken.de> (Thomas
        Bogendoerfer's message of "Tue, 25 Jul 2017 11:19:21 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chad.dupuis@cavium.com
List-Id: linux-scsi@vger.kernel.org


Thomas,

> FCOE offloading failed with:
>
> [qed_sp_fcoe_func_start:150(sp-0-3b:00.02)]Cannot satisfy CQ amount. CQs
> 		 requested 8, CQs available 6. Aborting function start
> [qed_fcoe_start:821()]Failed to start fcoe
> [__qedf_probe:3041]:6: Cannot start FCoE function.
>
> The reason is a newly introduced check in the qed main part. This
> change also provides the information about how many CQs are available,
> so we simply limit the number of requested CQs..

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
