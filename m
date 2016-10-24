From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/10] mpt3sas: Use the new MPI 2.6 32-bit Atomic Request
 Descriptors for SAS35 devices.
Date: Mon, 24 Oct 2016 16:52:31 +0200
Message-ID: <64e4db47-632f-a073-b5b7-8d1fa783de89@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-10-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-10-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> Support Atomic Request Descriptors for Ventura/SAS35 devices.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c      | 141 +++++++++++++++++++++++++++----
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  18 ++--
>  drivers/scsi/mpt3sas/mpt3sas_config.c    |   2 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  22 ++---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  24 +++---
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |   8 +-
>  6 files changed, 161 insertions(+), 54 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
