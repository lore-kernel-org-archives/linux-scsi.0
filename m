From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Wed, 19 Aug 2009 21:38:27 -0400
Message-ID: <4A8CA913.7020902@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org> <20090820011004.GC14005@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090820011004.GC14005@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Jamie Lokier wrote:
..
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
..

No, it doesn't.

A drive can optionally support "deterministic TRIM", whereby it will return
consistent data for any given trimmed sector afterwards, but that doesn't mean zeros.

-ml
