From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 03/11] au1100fb: remove a bogus dma_free_nonconsistent
 call
Date: Mon, 19 Jun 2017 13:15:04 +0200
Message-ID: <8727942.IUH8e0tH8t@amdc3058>
References: <20170616071716.17321-1-hch@lst.de>
        <20170616071716.17321-4-hch@lst.de>
        <CGME20170619111507epcas5p47fd18b90a02d827da256ff4ebbda8089@epcas5p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43043 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdFSLPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 07:15:10 -0400
In-reply-to: <20170616071716.17321-4-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org, netdev@vger.kernel.org, linux-metag@vger.kernel.org, nios2-dev@lists.rocketboards.org, linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org

On Friday, June 16, 2017 09:17:08 AM Christoph Hellwig wrote:
> au1100fb is using managed dma allocations, so it doesn't need to
> explicitly free the dma memory in the error path (and if it did
> it would have to use the managed version).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
