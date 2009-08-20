From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Wed, 19 Aug 2009 21:39:34 -0400
Message-ID: <4A8CA956.2060406@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090819203916.GA25296@elte.hu>
Sender: linux-ide-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[resending, after fixing the Cc: list; somebody trimmed it earlier]

Jamie Lokier wrote:
..
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
..

No, it doesn't.

A drive can optionally support "deterministic TRIM", whereby it will return
consistent data for any given trimmed sector afterwards, but that doesn't mean zeros.

-ml
