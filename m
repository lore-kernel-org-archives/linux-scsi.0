From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 05/18] block: allow specifying size for extra
 command data
Date: Fri, 27 Jan 2017 17:21:28 +0000
Message-ID: <1485537668.4267.7.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-6-git-send-email-hch@lst.de>
	<yq160l2a4us.fsf@oracle.com> <20170127161254.GA16557@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170127161254.GA16557@lst.de>
Content-Language: en-US
Content-ID: <6662E69A6592E042BF2B67D58A82AEDA@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-27 at 17:12 +0100, Christoph Hellwig wrote:
> On Wed, Jan 25, 2017 at 10:15:55PM -0500, Martin K. Petersen wrote:
> > +static void *alloc_request_size(gfp_t gfp_mask, void *data)
> > 
> > I like alloc_request_simple() but alloc_request_size() seems a bit
> > contrived. _reserve? _extra? _special? Don't have any good suggestions,
> > I'm afraid.
> 
> Not that I'm a fan of _size, but I like the other suggestions even less.

Hello Christoph and Martin,

How about using the function names alloc_full_request() / free_full_request()
together with a comment that mentions that cmd_size is set by the LLD?

Bart.
