From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 03/11] mpt3sas: Implement device_remove_in_progress
 check in IOCTL path
Date: Thu, 27 Oct 2016 10:54:52 +0200
Message-ID: <e3435c31-cbf6-1159-eb6a-afd074571595@suse.de>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1477469082-32395-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477469082-32395-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/26/2016 10:04 AM, Suganath Prabu S wrote:
> When device missing event arrives, device_remove_in_progress bit will be
> set and hence driver has to stop sending IOCTL commands.Now the check has
> been added in IOCTL path to test device_remove_in_progress bit is set, if
> so then IOCTL will be failed printing failure message.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 19 +++++++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  5 ++++
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 46 ++++++++++++++++++++++++++++++------
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 24 ++++++++++++++++++-
>  4 files changed, 86 insertions(+), 8 deletions(-)
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
