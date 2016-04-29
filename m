From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mptsas: fix checks for dma mapping errors
Date: Fri, 29 Apr 2016 13:13:36 -0600
Message-ID: <e4d00c4701ebcea4239019574ffc25fd@mail.gmail.com>
References: <1460761950-8006-1-git-send-email-khoroshilov@ispras.ru> <yq1wpnicyzq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1wpnicyzq.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

Please consider this patch as Ack-by: Sathya Prakash
Veerichetty<sathya.prakash@broadcom.com>

PS: We don't have test environment to test this patch as this is for an
old controller.  So ACKing based on code review and similar mpt3sas driver
code.

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Wednesday, April 27, 2016 7:18 PM
To: Alexey Khoroshilov
Cc: Sreekanth Reddy; Sathya Prakash; Chaitra P B; Suganath Prabu
Subramani; MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; ldv-project@linuxtesting.org
Subject: Re: [PATCH] mptsas: fix checks for dma mapping errors

>>>>> "Alexey" == Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

Alexey> mptsas_smp_handler() checks for dma mapping errors by comparison
Alexey> returned address with zero, while pci_dma_mapping_error() should
Alexey> be used.

Broadcom folks, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
