From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 00/10] be2iscsi: driver update 11.4.0.1
Date: Wed, 11 Oct 2017 11:56:23 -0700
Message-ID: <20171011185623.GB18827@straylight.hirudinean.org>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbdJKS40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Oct 2017 14:56:26 -0400
Content-Disposition: inline
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: lduncan@suse.com, linux-scsi@vger.kernel.org


These all look good to me.

Acked-by: Chris Leech <cleech@redhat.com>

On Tue, Oct 10, 2017 at 04:18:10PM +0530, Jitendra Bhivare wrote:
> This patch is generated against for-next branch.
> 
> Jitendra Bhivare (10):
>   be2iscsi: Fix boot flags in sysfs
>   be2iscsi: Fix return value in mgmt_open_connection
>   be2iscsi: Free msi_name and disable HW intr
>   be2iscsi: Fix _modify_eq_delay buffer overflow
>   be2iscsi: Fix _get_initname buffer overflow
>   be2iscsi: Modify IOCTL to fetch user configured IQN
>   be2iscsi: Add cmd to set host data
>   be2iscsi: Fix misc static analysis errors
>   be2iscsi: Remove A-circumflex character in copyright marking
>   scsi: be2iscsi: Update driver version
> 
>  drivers/scsi/be2iscsi/be.h       |  19 ++-
>  drivers/scsi/be2iscsi/be_cmds.c  |  55 +++++++-
>  drivers/scsi/be2iscsi/be_cmds.h  |  48 ++++---
>  drivers/scsi/be2iscsi/be_iscsi.c |  54 ++------
>  drivers/scsi/be2iscsi/be_iscsi.h |   2 +-
>  drivers/scsi/be2iscsi/be_main.c  | 102 ++++++++------
>  drivers/scsi/be2iscsi/be_main.h  |  49 +------
>  drivers/scsi/be2iscsi/be_mgmt.c  | 278 ++++++++++++++++++++++-----------------
>  drivers/scsi/be2iscsi/be_mgmt.h  |  10 +-
>  9 files changed, 323 insertions(+), 294 deletions(-)
> 
> -- 
> 2.7.4
> 
