From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 19/30] blk_end_request: changing ide-scsi (take 4)
Date: Wed, 12 Dec 2007 22:48:15 +0100
Message-ID: <200712122248.15838.bzolnier@gmail.com>
References: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:39779 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXLLW6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 17:58:00 -0500
Received: by ug-out-1314.google.com with SMTP id z38so724518ugc.16
        for <linux-scsi@vger.kernel.org>; Wed, 12 Dec 2007 14:57:58 -0800 (PST)
In-Reply-To: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Tuesday 11 December 2007, Kiyoshi Ueda wrote:
> This patch converts ide-scsi to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

looks good, ACK

ditto for patches #23 and #25
