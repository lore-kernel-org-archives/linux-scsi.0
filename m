From: James Smart <james.smart@broadcom.com>
Subject: Re: nvme-fc: fix status code handling in nvme_fc_fcpio_done
Date: Tue, 18 Apr 2017 14:08:33 -0700
Message-ID: <96441c26-93b1-751d-6995-d9d0fab00eee@broadcom.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
 <20170418155229.5977-3-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33472 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbdDRVIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 17:08:39 -0400
Received: by mail-wr0-f169.google.com with SMTP id l28so3171780wre.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 14:08:38 -0700 (PDT)
In-Reply-To: <20170418155229.5977-3-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@bombadil.infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>


On 4/18/2017 8:52 AM, Christoph Hellwig wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> nvme_complete_async_event expects the little endian status code
> including the phase bit, and a new completion handler I plan to
> introduce will do so as well.
>
> Change the status variable into the little endian format with the
> phase bit used in the NVMe CQE to fix / enable this.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>

look good

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>
