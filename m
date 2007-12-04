From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 20/28] blk_end_request: changing ide-scsi (take 3)
Date: Tue, 4 Dec 2007 14:47:03 +0100
Message-ID: <200712041447.04039.bzolnier@gmail.com>
References: <20071130.183243.66055473.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:48765 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbXLDNzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 08:55:22 -0500
Received: by ug-out-1314.google.com with SMTP id z38so77838ugc
        for <linux-scsi@vger.kernel.org>; Tue, 04 Dec 2007 05:55:20 -0800 (PST)
In-Reply-To: <20071130.183243.66055473.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> This patch converts ide-scsi to use blk_end_request().
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
