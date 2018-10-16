From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 10/11] block: add a report_zones method
Date: Tue, 16 Oct 2018 00:55:47 -0400
Message-ID: <yq1va62trqk.fsf@oracle.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012100850.23316-11-damien.lemoal@wdc.com> (Damien Le Moal's
	message of "Fri, 12 Oct 2018 19:08:49 +0900")
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

> Dispatching a report zones command through the request queue is a
> major pain due to the command reply payload rewriting necessary. Given
> that blkdev_report_zones() is executing everything synchronously,
> implement report zones as a block device file operation instead,
> allowing major simplification of the code in many places.
>
> sd, null-blk, dm-linear and dm-flakey being the only block device
> drivers supporting exposing zoned block devices, these drivers are
> modified to provide the device side implementation of the
> report_zones() block device file operation.
>
> For device mappers, a new report_zones() target type operation is
> defined so that the upper block layer calls blkdev_report_zones() can
> be propagated down to the underlying devices of the dm targets.
> Implementation for this new operation is added to the dm-linear and
> dm-flakey targets.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
