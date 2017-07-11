From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 05/13] mpt3sas: Set NVMe device queue depth as 128
Date: Tue, 11 Jul 2017 17:23:33 +0000
Message-ID: <AT5PR84MB00821C8CD515212788107EA0ABAE0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1499763313-7214-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499763313-7214-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, "hch@infradead.org" <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -115,7 +115,7 @@
> 
>  #define MPT3SAS_RAID_MAX_SECTORS	8192
>  #define MPT3SAS_HOST_PAGE_SIZE_4K	12
> -
> +#define MPT3SAS_NVME_QUEUE_DEPTH	128
...
> +		/*TODO-right Queue Depth?*/
> +		qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
> +		ds = "NVMe";

The native NVMe driver is getting a modparam to set that value (rather than
using a #define of 1024) in this patch:
	http://lists.infradead.org/pipermail/linux-nvme/2017-July/011734.html

Perhaps this driver should do the same.

---
Robert Elliott, HPE Persistent Memory
