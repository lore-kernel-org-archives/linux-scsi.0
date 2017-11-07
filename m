From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: fix dma_addr_t casts
Date: Mon, 06 Nov 2017 23:03:00 -0500
Message-ID: <yq17ev23fd7.fsf@oracle.com>
References: <20171106133540.506572-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171106133540.506572-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 6 Nov 2017 14:35:16 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, Romain Perier <romain.perier@collabora.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> After taking a closer look, I found that the problem is that the new
> code mixes up pointers and dma_addr_t values unnecessarily.
>
> This changes it to use the correct types consistently, which lets us
> get rid of a lot of type casts in the process. I'm also renaming some
> variables to avoid confusion between physical and dma address spaces
> that are often distinct.

Nice work! Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
