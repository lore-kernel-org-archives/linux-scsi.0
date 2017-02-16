From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: handle dma_addr_t right on 32-bit
Date: Wed, 15 Feb 2017 21:40:15 -0500
Message-ID: <yq1h93uc0z4.fsf@oracle.com>
References: <20170214212238.2696334-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170214212238.2696334-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 14 Feb 2017 22:21:51 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.com>, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> When building with a dma_addr_t that is different from pointer
Arnd> size, we get this warning:

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
