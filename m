From: Luben Tuikov <luben@splentec.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Tue, 04 Feb 2003 13:04:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4000C5.6040006@splentec.com>
References: <20030129104731.A2811@beaverton.ibm.com>	<3E382E2C.4030201@splentec.com>	<20030129121117.A3389@beaverton.ibm.com>	<20030130225738.1874c2e0.akpm@digeo.com>	<1044020591.2002.16.camel@mulgrave>	<20030131124412.086f2d1c.akpm@digeo.com>	<20030203225550.GJ29516@redhat.com>	<1044313513.1777.91.camel@mulgrave> <20030203151928.1f13c88a.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, dledford@redhat.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> 
> One could have designed it to support a pool of >1 command from the outset,
> but it's unlikely to be necessary.

Yes, I also that it's not likely to be necessary.

The functionality of support for more than one is there (i.e. in
the freeing-list code).  As I mentioned in this thread before,
I had *no* idea (and still have none) on _what_ number to settle if
greater than one.

OTOH, if the powers that be decide that more than one is
nevertheless necessary, a mempool, I think, would be quite appropriate.

-- 
Luben



