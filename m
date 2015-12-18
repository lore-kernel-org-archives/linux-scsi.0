From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/15] be2iscsi: driver update 11.0.0.0
Date: Fri, 18 Dec 2015 10:11:20 +0100
Message-ID: <5673CDB8.6030501@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966185AbbLRJLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:11:22 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Hi Jitendra,

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> This patch is generated against for-next branch.
>
> Jitendra (15):
>    be2iscsi: Fix soft lockup in mgmt_get_all_if_id path using bmbx
>    be2iscsi: Fix mbox synchronization replacing spinlock with mutex
>    be2iscsi: Fix to use atomic operations for tag_state
>    be2iscsi: Fix to synchronize tag allocation using spin_lock
>    be2iscsi: Set mbox timeout to 30s
>    be2iscsi: Added return value check for mgmt_get_all_if_id
>    be2iscsi: Fix to remove shutdown entry point
>    be2iscsi: Fix VLAN support for IPv6 network
>    be2iscsi: Fix to handle misconfigured optics events
>    be2iscsi: Add FW config validation
>    be2iscsi: Fix return value for MCC completion
>    be2iscsi: Fix IOPOLL implementation
>    be2iscsi: Fix to process 25G link speed info from FW
>    be2iscsi: Fix WRB leak in login/logout path
>    be2iscsi: Update the driver version
>
>   drivers/scsi/be2iscsi/be.h          |    4 +-
>   drivers/scsi/be2iscsi/be_cmds.c     |  368 ++++++++++++++++++------=
---------
>   drivers/scsi/be2iscsi/be_cmds.h     |  114 ++++++-----
>   drivers/scsi/be2iscsi/be_iscsi.c    |   54 ++---
>   drivers/scsi/be2iscsi/be_main.c     |  210 ++++++++++---------
>   drivers/scsi/be2iscsi/be_main.h     |   23 ++-
>   drivers/scsi/be2iscsi/be_mgmt.c     |  387 +++++++++++++++++++++---=
-----------
>   drivers/scsi/be2iscsi/be_mgmt.h     |    2 +
>   drivers/scsi/scsi_transport_iscsi.c |    2 +
>   include/scsi/iscsi_if.h             |    2 +
>   10 files changed, 648 insertions(+), 518 deletions(-)
>
Could you please add the 'Reviewed-by' tags (where applicable) if=20
you resend the patch series?
This saves us _quite_ some time, as we then can concentrate on the=20
patches which have changed, and can skip those which we already have=20
reviewed.
Otherwise we have to go through the entire patchset and figure out=20
if they are already reviewed, taking up quite some time.
Plus we might be finding other issues which we haven't seen on the=20
previous round :-)

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
