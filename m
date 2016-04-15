From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: fix possible NULL dereference
Date: Thu, 14 Apr 2016 22:43:57 -0400
Message-ID: <yq1mvovsiaa.fsf@sermon.lab.mkp.net>
References: <1460130162-30011-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460130162-30011-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Fri, 8 Apr 2016 21:12:42 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> We are dereferencing ioc->sense_dma_pool in pci_pool_free() and
Sudip> after that we are checking if it is NULL, before calling
Sudip> pci_pool_destroy().  Lets check if it is NULL before calling both
Sudip> pci_pool_free() and pci_pool_destroy().

Broadcom folks, please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
