From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 01/11] scsi: sd_zbc: Rearrange code
Date: Tue, 16 Oct 2018 00:48:02 -0400
Message-ID: <yq18t2yv6nx.fsf@oracle.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012100850.23316-2-damien.lemoal@wdc.com> (Damien Le Moal's
	message of "Fri, 12 Oct 2018 19:08:40 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Move the urswrz check out of sd_zbc_read_zones() and into
> sd_zbc_read_zoned_characteristics() where that value is obtained (read
> from the disk zoned characteristics VPD page). Since this function now
> does more than simply reading the VPD page, rename it to
> sd_zbc_check_zoned_characteristics().  Also fix the error message
> displayed when reading that VPD page fails.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
