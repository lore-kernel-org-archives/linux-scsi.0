From: Ingo Oeser <ingo.oeser@informatik.tu-chemnitz.de>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Thu, 15 May 2003 18:36:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030515183631.B626@nightmaster.csn.tu-chemnitz.de>
References: <20030514044934.GC29926@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030514044934.GC29926@holomorphy.com>; from wli@holomorphy.com on Tue, May 13, 2003 at 09:49:34PM -0700
To: William Lee Irwin III <wli@holomorphy.com>, gibbs@scsiguy.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 09:49:34PM -0700, William Lee Irwin III wrote:
> (6) uint32_t used instead of u32 (contrary to Linux conventions)

Where is this stated? 

uint32_t is C99 contrary to u32. It's valid
both in user and kernel space and allows to define ABI only once.

I use it both in user space and kernel code.

So I really need a _good_ reason, why this is against the
convention ;-)


Thanks & Regards

Ingo Oeser
