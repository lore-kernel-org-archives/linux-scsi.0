From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: 64-bit LUN support
Date: Wed, 10 Jun 2015 01:07:06 -0700
Message-ID: <1433923626.7916.162.camel@haakon3.risingtidesystems.com>
References: <1433918483-46849-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1433918483-46849-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On Wed, 2015-06-10 at 08:41 +0200, Hannes Reinecke wrote:
> Hi Nic,
> 
> here's now the patchset for making LIO-target support 64-bit LUNs.
> Pretty straightforward, plus an additional patch to remove the
> now obsolete limitation on 256 LUNs per TPG. There had been a
> comment in the header that REPORT LUN emulation would only support
> up to one page in payload, but I couldn't find any evidence for
> this in the code.
> 
> As usual, comments and reviews are welcome.
> 
> Patchset is relative to the 'for-next' branch of target-pending.
> 
> Hannes Reinecke (2):
>   target: use 64-bit LUNs
>   target: Remove TARGET_MAX_LUNS_PER_TRANSPORT
> 
>  drivers/target/iscsi/iscsi_target_tmr.c      |  4 +--
>  drivers/target/loopback/tcm_loop.c           |  4 +--
>  drivers/target/target_core_alua.c            |  2 +-
>  drivers/target/target_core_configfs.c        | 12 ++++----
>  drivers/target/target_core_device.c          | 39 ++++++++++---------------
>  drivers/target/target_core_fabric_configfs.c | 24 ++++------------
>  drivers/target/target_core_internal.h        | 10 +++----
>  drivers/target/target_core_pr.c              | 43 ++++++++++++++--------------
>  drivers/target/target_core_pr.h              |  6 ++--
>  drivers/target/target_core_tpg.c             | 13 ++-------
>  drivers/target/target_core_transport.c       |  6 ++--
>  drivers/target/target_core_ua.c              |  8 +++---
>  drivers/target/target_core_ua.h              |  2 +-
>  drivers/xen/xen-scsiback.c                   |  7 +++--
>  include/target/target_core_base.h            | 22 +++++++-------
>  include/target/target_core_fabric.h          | 10 +++----
>  16 files changed, 90 insertions(+), 122 deletions(-)
> 

Looks good, applied to target-pending/for-next.

Thanks for rebasing this to the latest for-next btw, and dropping the
last remaining TARGET_MAX_LUNS_PER_TRANSPORT vestiges as well.  :)

--nab
