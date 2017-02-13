From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] return valid data buffer length in scsi_bufflen() API
 using RQF_SPECIAL_PAYLOAD
Date: Mon, 13 Feb 2017 05:36:28 -0800
Message-ID: <20170213133628.GA3001@infradead.org>
References: <4c804c26dcaea4a30e89734bb351c523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbdBMNga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 08:36:30 -0500
Content-Disposition: inline
In-Reply-To: <4c804c26dcaea4a30e89734bb351c523@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, Jens Axboe <axboe@kernel.dk>

Hi Kashyap,

can you try 4.10-rc8?  It has "scsi: use blk_rq_payload_bytes" which
initializeѕ sdb->length to blk_rq_payload_bytes(), which should fix
your issue.
