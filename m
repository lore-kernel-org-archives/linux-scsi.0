From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Thu, 26 Aug 2010 20:40:44 -0400
Message-ID: <20100827004044.GA18731@redhat.com>
References: <20100727165627.GA474@lst.de>
 <20100727175418.GF6820@quack.suse.cz>
 <20100803184939.GA12198@lst.de>
 <20100803185148.GA12258@lst.de>
 <4C58F341.9060605@ct.jp.nec.com>
 <20100804085423.GA15687@lst.de>
 <4C5A1F05.40308@ce.jp.nec.com>
 <20100826225024.GB17832@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100826225024.GB17832@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 26 2010 at  6:50pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Once we have a need for using request-based DM for something other than
> multipath we can take a fresh look at implementing rq-based FLUSH+FUA.
> 
> Mike
> 
> p.s. I know how hard NEC worked on request-based DM's barrier support;
> so I'm not suggesting this lightly.  For me it just seems like we're
> carrying complexity in DM that hasn't ever been required.

To be clear: the piece that I was saying wasn't required is the need to
for request-based DM to clone a FLUSH to send to multiple targets
(saying as much was just a confusing distraction.. please ignore that).

Anyway, my previous email's question still stands.
