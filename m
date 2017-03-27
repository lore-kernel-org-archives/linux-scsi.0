From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/23] dm-kcopyd: switch to use
	REQ_OP_WRITE_ZEROES
Date: Mon, 27 Mar 2017 02:12:39 -0700
Message-ID: <20170327091239.GC6879@infradead.org>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-7-hch@lst.de>
	<20170323145522.GB17127@redhat.com> <20170323145651.GA31771@lst.de>
	<20170323151037.GC17127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170323151037.GC17127@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, philipp.reisner@linbit.com, linux-block@vger.kernel.org, dm-devel@redhat.com, lars.ellenberg@linbit.com, shli@kernel.org, Christoph Hellwig <hch@lst.de>, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 11:10:38AM -0400, Mike Snitzer wrote:
> Not sure why you've split out the dm-kcopyd patch, likely best to just
> fold it into the previous dm support patch.

The dm-kcopyd patch switches to using WRITE_ZEROES instead of write
same for dm as user of these interfaces.  The one before just adds
WRITE_ZEROES support to dm.
