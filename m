From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.0-test4-mm5: SCSI imm driver doesn't compile
Date: Thu, 4 Sep 2003 15:30:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030904153023.A32549@infradead.org>
References: <20030902231812.03fae13f.akpm@osdl.org> <20030903170256.GA18025@fs.tum.de> <20030904133056.GA2411@conectiva.com.br> <20030904135256.GS14376@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030904135256.GS14376@lug-owl.de>; from jbglaw@lug-owl.de on Thu, Sep 04, 2003 at 03:52:56PM +0200
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Arnaldo Carvalho de Melo <acme@conectiva.com.br>, Adrian Bunk <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, campbell@torque.net
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 04, 2003 at 03:52:56PM +0200, Jan-Benedict Glaw wrote:
> C99 style is
> 
> 	.element = initializer,
> 
> not
> 	[element] = initializer,
> 
> which is a GNU/GCCism.

We're talking about arrays here..

.element obviously never works for arrays and [constant] never
works for structs..
