From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/25] virtio_blk: don't use req->errors
Date: Thu, 6 Apr 2017 20:55:42 +0200
Message-ID: <20170406185541.GE8673@linux-x5ow.site>
References: <20170406153944.10058-1-hch@lst.de>
	<20170406153944.10058-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170406153944.10058-8-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 06, 2017 at 05:39:26PM +0200, Christoph Hellwig wrote:
> Remove passing req->errors (which at that point is always 0) to
> blk_mq_complete_requestq, and rely on the virtio status code for the
blk_mq_complete_request ^

> serial number passthrough request.
> =

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Otherwise looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
