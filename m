From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
Date: Fri, 24 Oct 2014 02:25:05 -0700
Message-ID: <20141024092505.GA28925@infradead.org>
References: <5449529D.5070804@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5449529D.5070804@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 23, 2014 at 03:10:21PM -0400, Tony Battersby wrote:
> Fix a memory leak with scsi-mq triggered by commands with large data
> transfer length.

Thanks, this was indeed caused by a last minute change due to someone
complaining about my earlier version being a little too convoluted.

Thanks for tracking this down!
