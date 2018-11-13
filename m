From: Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH 5/8] bsg: refactor bsg_ioctl
Date: Tue, 13 Nov 2018 15:05:50 +0100
Message-ID: <20181113140550.GA7222@w530-pk1mzal>
References: <20181111133211.13926-1-hch@lst.de>
 <20181111133211.13926-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181111133211.13926-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2018 at 02:32:08PM +0100, Christoph Hellwig wrote:
> Move all actual functionality into helpers, just leaving the dispatch
> in this function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg.c | 158 ++++++++++++++++++++++++----------------------------
>  1 file changed, 72 insertions(+), 86 deletions(-)
>

Looks fine to me. Did ran the same small test-tool I ran against Jens'
patches, nothing broke.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Tested-by: Benjamin Block <bblock@linux.ibm.com>

-- 
With Best Regards, Benjamin Block      /      Linux on IBM Z Kernel Development
IBM Systems & Technology Group   /  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz       /      Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
