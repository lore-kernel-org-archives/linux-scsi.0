From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 00/16] libfc, libfcoe and fcoe updates for 3.8
Date: Sun, 16 Dec 2012 11:56:55 -0800
Message-ID: <50CE2787.6020505@broadcom.com>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1274 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2LPT7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Dec 2012 14:59:32 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org

On 12/12/2012 03:22 PM, Robert Love wrote:
> There are two primary changes within this update. Additionally there are two or three fix/cleanup patches.
>
> The first change is the addition of the fcoe_sysfs "control" interfaces. These patches were well vetted on the scsi mailing list and have only seen validation and a minor fix or two, as the result testing, since the last RFC posting.
>
> The second change is a cleanup/consolidation series from Yi that touches libfcoe.ko, fcoe.ko and bnx2fc.ko. These patches were well vetted on the fcoe mailing list and should be good to go as well. They make no functional change.
>
> I will compose a pull-request and send it soon, but I wanted to make sure the most recent versions of these patches were posted to linux-scsi first.
>
> ---
>
> Al Viro (1):
>        debris left by "[SCSI] libfcoe: Remove mutex_trylock/restart_syscall checks"
>
> Robert Love (7):
>        Documentation: Add missing devices/ to devices path
>        libfcoe: Save some memory and optimize name lookups
>        libfcoe: Add fcoe_sysfs debug logging level
>        libfcoe, fcoe, bnx2fc: Add new fcoe control interface
>        fcoe: Use the fcoe_sysfs control interface
>        bnx2fc: Use the fcoe_sysfs control interface
>        libfc, libfcoe, fcoe: Convert debug_logging macros to pr_info
>
> Vasu Dev (1):
>        libfc: fix REC handling
>
> Yi Zou (7):
>        fcoe: prep work to start consolidate the usage of fcoe_netdev
>        fcoe: add support to the get_netdev() for fcoe_interface
>        libfcoe, fcoe: move fcoe_link_speed_update() to libfcoe and export it
>        libfcoe, fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
>        bnx2fc: add support to get_netdev for bnx2f_interface
>        bnx2fc: use fcoe_link_speed_update() from the exported symbol in libfcoe
>        bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly from libfcoe
>
>
>   Documentation/ABI/testing/sysfs-bus-fcoe |   45 +++++
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  256 +++++++++++++++++-------------
>   drivers/scsi/fcoe/fcoe.c                 |  212 +++++++++++++++----------
>   drivers/scsi/fcoe/fcoe.h                 |    6 -
>   drivers/scsi/fcoe/fcoe_ctlr.c            |   17 +-
>   drivers/scsi/fcoe/fcoe_sysfs.c           |  186 ++++++++++++++++++----
>   drivers/scsi/fcoe/fcoe_transport.c       |  199 +++++++++++++++++++++++
>   drivers/scsi/fcoe/libfcoe.h              |   20 +-
>   drivers/scsi/libfc/fc_fcp.c              |    6 -
>   drivers/scsi/libfc/fc_libfc.h            |   38 ++--
>   include/scsi/fcoe_sysfs.h                |   11 +
>   include/scsi/libfcoe.h                   |   32 ++++
>   12 files changed, 749 insertions(+), 279 deletions(-)
>
Changes look good to me, except for the minor comment in patch 5.

Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


