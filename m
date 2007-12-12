From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 21/30] blk_end_request: changing cciss (take 4)
Date: Wed, 12 Dec 2007 19:08:09 +0000
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15718F19@G6W0268.americas.hpqcorp.net>
References: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
	<DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
 <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

> >
> > Why is this removed?
>
> Sorry for the less explanation.
>
> Because it is done in __end_that_request_first() called from
> blk_end_request().
> I'll add the explanation to the patch description when I
> update the patch.
>

Thank you. I've Acked the patch.

-- mikem
