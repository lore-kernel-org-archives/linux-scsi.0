From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v4 3/5] nvmet/fc: Use sgl_alloc() and sgl_free()
Date: Fri, 5 Jan 2018 08:33:35 -0800
Message-ID: <b456f605-76e4-d47a-d525-7176a78103e6@broadcom.com>
References: <20180105162650.31083-1-bart.vanassche@wdc.com>
 <20180105162650.31083-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:47044 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbeAEQdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 11:33:38 -0500
Received: by mail-qk0-f196.google.com with SMTP id l12so6223741qke.13
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 08:33:38 -0800 (PST)
In-Reply-To: <20180105162650.31083-4-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>

On 1/5/2018 8:26 AM, Bart Van Assche wrote:
> Use the sgl_alloc() and sgl_free() functions instead of open coding
> these functions.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> ---
>   drivers/nvme/target/Kconfig |  1 +
>   drivers/nvme/target/fc.c    | 36 ++----------------------------------
>   2 files changed, 3 insertions(+), 34 deletions(-)

Reviewed-by:  James Smart <james.smart@broadcom.com>

-- james
