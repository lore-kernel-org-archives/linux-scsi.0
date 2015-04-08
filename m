From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 1/2] target/rd: reduce code duplication in
 rd_execute_rw()
Date: Tue, 07 Apr 2015 22:03:31 -0700
Message-ID: <1428469411.18203.23.camel@haakon3.risingtidesystems.com>
References: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2015-04-05 at 23:59 +0900, Akinobu Mita wrote:
> Factor out code duplication in rd_execute_rw() into a helper function
> rd_do_prot_rw().  This change is required to minimize the forthcoming
> fix in rd_do_prot_rw().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
> * v2
> - Pass dif_verify() function pointer to helper function instead of is_write,
>   suggested by Sagi Grimberg.
> 
>  drivers/target/target_core_rd.c | 66 ++++++++++++++++++++---------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)

Nice patch.  Applied to for-next with a bit of fuzz due to the
WRITE_STRIP + READ_INSERT related changes already queued up..

Thanks Akinobu!

--nab
