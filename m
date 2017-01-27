From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/18] block: allow specifying size for extra
	command	data
Date: Fri, 27 Jan 2017 17:12:54 +0100
Message-ID: <20170127161254.GA16557@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-6-git-send-email-hch@lst.de>
	<yq160l2a4us.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq160l2a4us.fsf@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2017 at 10:15:55PM -0500, Martin K. Petersen wrote:
> +static void *alloc_request_size(gfp_t gfp_mask, void *data)
> 
> I like alloc_request_simple() but alloc_request_size() seems a bit
> contrived. _reserve? _extra? _special? Don't have any good suggestions,
> I'm afraid.

Not that I'm a fan of _size, but I like the other suggestions even less.
