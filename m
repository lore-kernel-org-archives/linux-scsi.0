From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH v3 00/10] be2iscsi: driver update 11.4.0.0
Date: Fri, 24 Mar 2017 09:52:05 -0700
Message-ID: <20170324165205.tccvvkt6lenzh7zm@straylight.hirudinean.org>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757362AbdCXQwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 12:52:08 -0400
Content-Disposition: inline
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: thenzl@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org

This series looks good to me.

Reviewed-by: Chris Leech <cleech@redhat.com>

On Fri, Mar 24, 2017 at 02:11:39PM +0530, Jitendra Bhivare wrote:
> This patch is generated against for-next branch.
> 
> v3 changes:
>  be2iscsi: Fix closing of connection
>  	- Fixed per Tomas's review comments.
> 
> v2 changes:
>  +be2iscsi: Update Copyright
> 
> Jitendra Bhivare (10):
>   be2iscsi: Check tag in beiscsi_mccq_compl_wait
>   be2iscsi: Fix closing of connection
>   be2iscsi: Replace spin_unlock_bh with spin_lock
>   scsi_transport_iscsi: Use flush_work in iscsi_remove_session
>   be2iscsi: Increase HDQ default queue size
>   be2iscsi: Use num_cons field in Rx CQE
>   be2iscsi: Remove free_list for ASYNC handles
>   be2iscsi: Check size before copying ASYNC handle
>   be2iscsi: Update Copyright
>   be2iscsi: Update driver version
> 
>  drivers/scsi/be2iscsi/be.h          |  12 +-
>  drivers/scsi/be2iscsi/be_cmds.c     |  17 ++-
>  drivers/scsi/be2iscsi/be_cmds.h     |  74 +++++-----
>  drivers/scsi/be2iscsi/be_iscsi.c    | 111 ++++++++-------
>  drivers/scsi/be2iscsi/be_iscsi.h    |  13 +-
>  drivers/scsi/be2iscsi/be_main.c     | 270 +++++++++++++++---------------------
>  drivers/scsi/be2iscsi/be_main.h     |  28 ++--
>  drivers/scsi/be2iscsi/be_mgmt.c     | 140 +++++++++----------
>  drivers/scsi/be2iscsi/be_mgmt.h     |  43 ++----
>  drivers/scsi/scsi_transport_iscsi.c |   3 +-
>  10 files changed, 319 insertions(+), 392 deletions(-)
> 
> -- 
> 2.7.4
> 
