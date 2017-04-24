From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mvumi: remove code handling zero
 scsi_sg_count(scmd) case
Date: Sun, 23 Apr 2017 23:36:22 -0700
Message-ID: <20170424063622.GA24410@infradead.org>
References: <20170423084133.GE30869@infradead.org>
 <1492988460-453-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38657 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165551AbdDXGg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 02:36:27 -0400
Content-Disposition: inline
In-Reply-To: <1492988460-453-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Note that there is plenty opportunity for cleanup even in the moved
code section, but let's get this issue sorted out only for now.
