From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ibmvscsis: Enable Logical Partition Migration Support
Date: Tue, 23 May 2017 20:34:48 -0700
Message-ID: <1495596888.27407.35.camel@haakon3.risingtidesystems.com>
References: <1494974961-30928-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34611 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdEXDev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 23:34:51 -0400
In-Reply-To: <1494974961-30928-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2017-05-16 at 17:49 -0500, Bryant G. Ly wrote:
> From: Michael Cyr <mikecyr@us.ibm.com>
> 
> Changes to support a new mechanism from phyp to better synchronize the
> logical partition migration (LPM) of the client partition.
> This includes a new VIOCTL to register that we support this new
> functionality, and 2 new Transport Event types, and finally another
> new VIOCTL to let phyp know once we're ready for the Suspend.
> 
> Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 148 ++++++++++++++++++++++++++++---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |  25 +++++-
>  drivers/scsi/ibmvscsi_tgt/libsrp.h       |   5 +-
>  3 files changed, 162 insertions(+), 16 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Bryant & Co.
