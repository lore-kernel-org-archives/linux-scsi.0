From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3] target/user: PGR Support
Date: Mon, 01 May 2017 22:02:00 -0700
Message-ID: <1493701320.23202.47.camel@haakon3.risingtidesystems.com>
References: <1492825250-44236-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50419 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEBFCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 01:02:02 -0400
In-Reply-To: <1492825250-44236-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mchristi@redhat.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Fri, 2017-04-21 at 20:40 -0500, Bryant G. Ly wrote:
> This adds initial PGR support for just TCMU, since tcmu doesn't
> have the necessary IT_NEXUS info to process PGR in userspace,
> so have those commands be processed in kernel.
> 
> HA support is not available yet, we will work on it if this patch
> is acceptable.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_configfs.c | 10 ++++-----
>  drivers/target/target_core_device.c   | 38 +++++++++++++++++++++++++++++++++++
>  drivers/target/target_core_pr.c       |  2 +-
>  drivers/target/target_core_pscsi.c    |  3 ++-
>  include/target/target_core_backend.h  |  1 +
>  5 files changed, 47 insertions(+), 7 deletions(-)

Applied.

Thanks alot for adding the target_cmd_size_check() into
passthrough_parse_cdb(), btw.  :)
