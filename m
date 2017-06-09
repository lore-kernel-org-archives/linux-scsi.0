From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 0/5] tcmu: Add Type of reconfig into netlink
Date: Thu, 08 Jun 2017 23:11:46 -0700
Message-ID: <1496988706.28997.40.camel@haakon3.risingtidesystems.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33381 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFIGLs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 02:11:48 -0400
In-Reply-To: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mchristi@redhat.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>

Hi Bryant & Co,

On Tue, 2017-06-06 at 09:28 -0500, Bryant G. Ly wrote:
> From: "Bryant G. Ly" <bgly@us.ibm.com>
> 
> This patch consists of adding a netlink to allow for reconfiguration
> of a device in tcmu.
> 
> It also changes and adds some attributes that are reconfigurable:
> write_cache, device size, and device path.
> 
> V2 - Fixes kfree in tcmu: Make dev_config configurable
> V3 - Fixes spelling error
> V4 - change strcpy to strlcpy for tcmu_dev_path_store and move
>      tcmu_reconfig_type into target_core_user.h
> 
> 
> Bryant G. Ly (5):
>   tcmu: Support emulate_write_cache
>   tcmu: Add netlink for device reconfiguration
>   tcmu: Make dev_size configurable via userspace
>   tcmu: Make dev_config configurable
>   tcmu: Add Type of reconfig into netlink
> 
>  drivers/target/target_core_user.c     | 152 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/target_core_user.h |   9 ++
>  2 files changed, 155 insertions(+), 6 deletions(-)
> 

AFAICT, it looks like all of the review comments have been addressed in
-v4.

Applied to target-pending/for-next, with MNC's (pseudo) Reviewed-by's
added for #3-#5.

Please let me know if anything else needs to be changed.
