From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 0/5] TCMU Enable Reconfiguration Patches
Date: Fri, 02 Jun 2017 23:58:03 -0700
Message-ID: <1496473083.27407.315.camel@haakon3.risingtidesystems.com>
References: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55392 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdFCG6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2017 02:58:05 -0400
In-Reply-To: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mchristi@redhat.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Bryant & Co,

On Tue, 2017-05-30 at 13:31 -0500, Bryant G. Ly wrote:
> This patch consists of adding a netlink to allow for reconfiguration
> of a device in tcmu.
> 
> It also changes and adds some attributes that are reconfigurable:
> write_cache, device size, and device path.
> 
> Bryant G. Ly (5):
>   tcmu: Support emulate_write_cache
>   tcmu: Add netlink for device reconfiguration
>   tcmu: Make dev_size configurable via userspace
>   tcmu: Make dev_config configurable
>   tcmu: Add Type of reconfig into netlink
> 
>  drivers/target/target_core_user.c     | 159 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/target_core_user.h |   2 +
>  2 files changed, 155 insertions(+), 6 deletions(-)
> 

Are these ready for merge..?

MNC..?
