From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptsas: fix checks for dma mapping errors
Date: Wed, 27 Apr 2016 21:18:17 -0400
Message-ID: <yq1wpnicyzq.fsf@sermon.lab.mkp.net>
References: <1460761950-8006-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460761950-8006-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Sat, 16 Apr 2016 02:12:29 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alexey" == Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

Alexey> mptsas_smp_handler() checks for dma mapping errors by comparison
Alexey> returned address with zero, while pci_dma_mapping_error() should
Alexey> be used.

Broadcom folks, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
