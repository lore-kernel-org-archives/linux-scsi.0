From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: fix a missing check of devm_reset_control_get
Date: Tue, 19 Mar 2019 14:37:35 -0400
Message-ID: <yq1y35ad828.fsf@oracle.com>
References: <SN6PR04MB4925DB2652FAED5F3AED27CCFC4B0@SN6PR04MB4925.namprd04.prod.outlook.com>
        <20190315071156.21588-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315071156.21588-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Fri, 15 Mar 2019 02:11:56 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kangjie,

> devm_reset_control_get could fail, so the fix checks its return value
> and passes the error code upstream in case it fails.

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
