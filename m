From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] qla2xxx: Reduce exess wait during chip reset
Date: Tue, 20 Dec 2016 06:14:41 -0800
Message-ID: <20161220141441.GH16487@infradead.org>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
 <1482208424-12358-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482208424-12358-9-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2016 at 08:33:42PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Soft reset and Risc reset should take 100uS to complete.
> This change pad the timeout up to 400uS, which should be
> plenty.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
