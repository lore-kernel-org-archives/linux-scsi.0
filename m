From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 3/6] sg: prevent integer overflow when converting from
 sectors to bytes
Date: Mon, 02 Jun 2014 13:05:26 -0400
Message-ID: <538CAED6.6070603@interlog.com>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com> <1401717409-5236-4-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58948 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbaFBRFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 13:05:34 -0400
In-Reply-To: <1401717409-5236-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 14-06-02 09:56 AM, Akinobu Mita wrote:
> This prevents integer overflow when converting the request queue's
> max_sectors from sectors to bytes.  However, this is a preparation for
> extending the data type of max_sectors in struct Scsi_Host and
> scsi_host_template.  So, it is impossible to happen this integer
> overflow for now, because SCSI low-level drivers can not specify
> max_sectors greater than 0xffff due to the data type limitation.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> This patch is a part of the v1 "scsi: increase upper limit for
> max_sectors" patch.

Acked by: Douglas Gilbert <dgilbert@interlog.com>

