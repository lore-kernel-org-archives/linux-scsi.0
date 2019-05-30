From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask in pqi_pci_init()
Date: Wed, 29 May 2019 22:00:11 -0400
Message-ID: <yq14l5czopg.fsf@oracle.com>
References: <20190527005934.1493-1-lijiang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527005934.1493-1-lijiang@redhat.com> (Lianbo Jiang's
        message of "Mon, 27 May 2019 08:59:34 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Lianbo Jiang <lijiang@redhat.com>
Cc: linux-kernel@vger.kernel.org, don.brace@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Thomas.Lendacky@amd.com, dyoung@redhat.com
List-Id: linux-scsi@vger.kernel.org


Lianbo,

> When SME is enabled, the smartpqi driver won't work on the HP DL385
> G10 machine, which causes the failure of kernel boot because it fails
> to allocate pqi error buffer. Please refer to the kernel log:

Applied to 5.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
