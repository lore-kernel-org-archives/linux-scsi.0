From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/13] mpt3sas: Handle NVMe PCIe device related events
 generated from firmware.
Date: Thu, 3 Aug 2017 08:38:05 +0200
Message-ID: <62d621e7-2adc-05b1-e914-dcda52b41553@suse.de>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1500038560-11231-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
> * The controller firmware sends separate events for NVMe devices and
> PCIe switches similar to existing SAS events.
> 
> * NVMe device detection, addition and removal are reported by the
> firmware through PCIe Topology Change list events.
> 
> * The PCIe device state change events are sent when the firmware
> detects any abnormal conditions with a NVMe device or switch.
> 
> * The enumeration event are sent when the firmware starts PCIe device
> enumeration and stops.
> 
> * This patch has the code change to handle the events and add/remove
> NVMe devices in driver's inventory.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  |   30 ++-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  471 +++++++++++++++++++++++++++++++++-
>  2 files changed, 495 insertions(+), 6 deletions(-)
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
