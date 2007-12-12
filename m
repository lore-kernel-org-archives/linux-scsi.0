From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 21/30] blk_end_request: changing cciss (take
	4)
Date: Wed, 12 Dec 2007 12:27:52 -0500 (EST)
Message-ID: <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
References: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
	<DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike.Miller@hp.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

On Wed, 12 Dec 2007 15:25:10 +0000, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:
> > Index: 2.6.24-rc4/drivers/block/cciss.c
> > ===================================================================
> > --- 2.6.24-rc4.orig/drivers/block/cciss.c
> > +++ 2.6.24-rc4/drivers/block/cciss.c
snip
> > +2526,6 @@ after_error_processing:
> >         }
> >         cmd->rq->data_len = 0;
> >         cmd->rq->completion_data = cmd;
> > -       blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
> 
> Why is this removed?

Sorry for the less explanation.

Because it is done in __end_that_request_first() called from
blk_end_request().
I'll add the explanation to the patch description when I update
the patch.

Thanks,
Kiyoshi Ueda
