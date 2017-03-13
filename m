From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: make ata_sg_clean static over again
Date: Mon, 13 Mar 2017 13:08:53 -0400
Message-ID: <20170313170853.GC15709@htj.duckdns.org>
References: <1489111540-22046-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33499 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbdCMRI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 13:08:56 -0400
Content-Disposition: inline
In-Reply-To: <1489111540-22046-1-git-send-email-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: linux-ide@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, miaoxie@huawei.com

On Fri, Mar 10, 2017 at 10:05:40AM +0800, Jason Yan wrote:
> Fixes the following sparse warning:
> 
> drivers/ata/libata-core.c:4913:6: warning: symbol 'ata_sg_clean' was not
> declared. Should it be static?
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied to libata/for-4.12.

Thanks.

-- 
tejun
