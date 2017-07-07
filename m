From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/5] target: pscsi: Introduce TYPE_ZBC support
Date: Thu, 06 Jul 2017 22:00:44 -0700
Message-ID: <1499403644.30628.31.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59949 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdGGFAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 01:00:46 -0400
In-Reply-To: <20170628055900.22889-3-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Wed, 2017-06-28 at 14:58 +0900, Damien Le Moal wrote:
> TYPE_ZBC host managed zoned block devices are also block devices
> despite the non-standard device type (14h). Handle them similarly to
> regular TYPE_DISK devices.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_pscsi.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Applied to target-pending/for-next.

Thanks.
