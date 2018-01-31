From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 31 Jan 2018 11:33:49 +0800
Message-ID: <20180131033348.GA9985@ming.t460p>
References: <20180130142459.52668-1-snitzer@redhat.com>
	<43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
	<7baf8e0f-7a15-4529-c32b-4ce0ee172598@kernel.dk>
	<1517368861.4421.2.camel@wdc.com>
	<d563628f-687d-c463-7e7e-d85a52cdf25b@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d563628f-687d-c463-7e7e-d85a52cdf25b@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 08:22:27PM -0700, Jens Axboe wrote:
> On 1/30/18 8:21 PM, Bart Van Assche wrote:
> > On Tue, 2018-01-30 at 20:17 -0700, Jens Axboe wrote:
> >> BLK_STS_RESOURCE should always be safe to return, and it should work
> >> the same as STS_DEV_RESOURCE, except it may cause an extra queue
> >> run.
> >>
> >> Well written drivers should use STS_DEV_RESOURCE where it makes
> >> sense.
> > 
> > Hello Jens,
> > 
> > I would appreciate it if other names would be chosen than BLK_STS_RESOURCE
> > and BLK_STS_DEV_RESOURCE, e.g. names that directly refer to the fact that
> > one of the two status codes causes the queue to be rerun and the other not.
> > I'm afraid that the currently chosen names will cause confusion.
> 
> DEV_RESOURCE is pretty clear I think, but I agree that STS_RESOURCE
> could perhaps be better. STS_SYSTEM_RESOURCE? It makes the distinction

I guess it still can't cover all, for example, .queue_rq() may not
submit rq to hardware successfully because of tansport busy, such FC,..

-- 
Ming
