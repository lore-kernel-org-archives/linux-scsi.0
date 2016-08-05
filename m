From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/28] be2iscsi: driver update 11.2.0.0
Date: Fri, 5 Aug 2016 18:42:09 +0200
Message-ID: <7bd1dcad-e0bc-d31d-2ddc-2336d1b9f516@suse.de>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895AbcHEQmM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 12:42:12 -0400
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com

On 07/21/2016 11:07 AM, Jitendra Bhivare wrote:
> This patch is generated against for-next branch.
>
> Jitendra Bhivare (28):
>   be2iscsi: Fix to use correct configuration values
>   be2iscsi: Replace _bh with _irqsave/irqrestore
>   be2iscsi: Replace _bh version for mcc_lock spinlock
>   be2iscsi: Reduce driver load/unload time
>   be2iscsi: Set and return right iface v4/v6 states
>   be2iscsi: Fix gateway APIs to support IPv4 & IPv6
>   be2iscsi: Fix release of DHCP IP in static mode
>   be2iscsi: Move VLAN code to common iface_set_param
>   be2iscsi: Update iface handle before any set param
>   be2iscsi: Rename iface get/set/create/destroy APIs
>   be2iscsi: Handle only NET_PARAM in iface_get_param
>   be2iscsi: Check all zeroes IP before issuing IOCTL
>   be2iscsi: Remove alloc_mcc_tag & beiscsi_pci_soft_reset
>   be2iscsi: Remove isr_lock and dead code
>   be2iscsi: Fix checks for HBA in error state
>   be2iscsi: Fix to make boot discovery non-blocking
>   be2iscsi: Fix to add timer for UE detection
>   be2iscsi: Add IOCTL to check UER supported
>   be2iscsi: Move functions to right files
>   be2iscsi: Fix POST check and reset sequence
>   be2iscsi: Add V1 of EPFW cleanup IOCTL
>   be2iscsi: Add TPE recovery feature
>   be2iscsi: Fail the sessions immediately after TPE
>   be2iscsi: Add FUNCTION_RESET during driver unload
>   be2iscsi: Fix async PDU handling path
>   be2iscsi: Update copyright information
>   be2iscsi: Update the driver version
>   MAINTAINERS: Update be2iscsi contact info
>
>  MAINTAINERS                      |   10 +-
>  drivers/scsi/be2iscsi/be.h       |   15 +-
>  drivers/scsi/be2iscsi/be_cmds.c  | 1096 +++++++++++------
>  drivers/scsi/be2iscsi/be_cmds.h  |  142 ++-
>  drivers/scsi/be2iscsi/be_iscsi.c |  408 +++----
>  drivers/scsi/be2iscsi/be_iscsi.h |   25 +-
>  drivers/scsi/be2iscsi/be_main.c  | 2476 +++++++++++++++++++-------------------
>  drivers/scsi/be2iscsi/be_main.h  |  220 ++--
>  drivers/scsi/be2iscsi/be_mgmt.c  | 1490 +++++++++--------------
>  drivers/scsi/be2iscsi/be_mgmt.h  |   51 +-
>  10 files changed, 3052 insertions(+), 2881 deletions(-)
>
For the entire patchset:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
