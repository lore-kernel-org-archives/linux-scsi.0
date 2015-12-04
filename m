From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mpt3sas: add PCI dependency for CONFIG_SCSI_MPT2SAS
Date: Fri, 04 Dec 2015 08:28:51 -0800
Message-ID: <1449246531.27077.5.camel@HansenPartnership.com>
References: <1953916.xaj9Y2FReq@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1953916.xaj9Y2FReq@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-12-04 at 15:27 +0100, Arnd Bergmann wrote:
> CONFIG_SCSI_MPT2SAS was added as a backwards-compatibility helper that
> selects the replacement SCSI_MPT3SAS symbol, but lacks the dependencies:
> 
> warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS which has unmet direct dependencies (SCSI_LOWLEVEL && PCI && SCSI)
> 0x7E5F9A79 Fri Dec 4 12:36:08 CET 2015 failed
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function 'mpt3sas_remove_dead_ioc_func':
> drivers/scsi/mpt3sas/mpt3sas_base.c:140:2: error: implicit declaration of function 'pci_stop_and_remove_bus_device_locked' [-Werror=implicit-function-declaration]
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_base_disable_msix':
> drivers/scsi/mpt3sas/mpt3sas_base.c:1921:2: error: implicit declaration of function 'pci_disable_msix' [-Werror=implicit-function-declaration]
> 
> This adds the same dependencies that SCSI_MPT3SAS has.

OK, you're about the fifth person to complain about this and this patch
was posted a few days ago and is now here:

http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?h=fixes&id=3ddda3e4c82dea58933bde8d0f6ef34470c360cb

It's even been in for-next for nearly 24h

James
