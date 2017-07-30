From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2] tcmu: Add fifo type waiter list support to avoid
 starvation
Date: Sun, 30 Jul 2017 15:10:45 -0700
Message-ID: <1501452645.1499.21.camel@haakon3.daterainc.com>
References: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:32944 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbdG3WKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jul 2017 18:10:46 -0400
In-Reply-To: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Xiubo,

Apologies for the delayed response.  Comments below.

On Wed, 2017-07-12 at 15:16 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> The fifo type waiter list will hold the udevs who are waiting for the
> blocks from the data global pool. The unmap thread will try to feed the
> first udevs in waiter list, if the global free blocks available are
> not enough, it will stop traversing the list and abort waking up the
> others.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 104 ++++++++++++++++++++++++++++++++------
>  1 file changed, 88 insertions(+), 16 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Xiubo + MNC.
