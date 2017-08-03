From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 04/13] mpt3sas: Added support for nvme encapsulated
 request message.
Date: Thu, 3 Aug 2017 08:33:13 +0200
Message-ID: <75dcdeda-5f3c-cef0-9957-4588ac9624cc@suse.de>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1500038560-11231-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
> * Mpt3sas driver uses the NVMe Encapsulated Request message to
> send an NVMe command to an NVMe device attached to the IOC.
> 
> * Normal I/O commands like reads and writes are passed to the
> controller as SCSI commands and the controller has the ability
> to translate the commands to NVMe equivalent.
> 
> * This encapsulated NVMe command is used by applications to send
> direct NVMe commands to NVMe drives or for handling unmap where
> the translation at controller/firmware level is having
> performance issues.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c |   56 ++++++++++++++++++++++++++++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h |    1 +
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c  |   69 ++++++++++++++++++++++++++++++++---
>  3 files changed, 119 insertions(+), 7 deletions(-)
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
