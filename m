From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH] scsi: Fix the comment of sd_major
Date: Tue, 8 Apr 2014 13:24:16 +0800
Message-ID: <53438800.6040801@huawei.com>
References: <534385F5.9070606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:59442 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaDHFY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 01:24:27 -0400
In-Reply-To: <534385F5.9070606@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2014/4/8 13:15, hujianyang wrote:
> Fix the comment of sd_major to right major numbers.
> 
> Signed-off-by: root <root@FsServer.EulerKernel>
> 
> ---
>  drivers/scsi/sd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 470954a..02ff975 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -529,7 +529,7 @@ static struct kobject *sd_default_probe(dev_t devt, int *partno, void *data)
>   * ones with major1, ... Disk 256 is for major0 again, disk 272
>   * for major1, ...
>   * As we stay compatible with our numbering scheme, we can reuse
> - * the well-know SCSI majors 8, 65--71, 136--143.
> + * the well-know SCSI majors 8, 65--71, 128--135.
>   */
>  static int sd_major(int major_idx)
>  {
> 

Forgot to change the signed-off part.

Sorry for that.

I will send a new patch.

