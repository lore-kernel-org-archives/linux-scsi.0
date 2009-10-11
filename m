From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Date: Sun, 11 Oct 2009 09:03:13 -0700
Message-ID: <20091011090313.1b8f0eb1@infradead.org>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
	<20091011165408.51d4f413@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755316AbZJKQDX@vger.kernel.org>
In-Reply-To: <20091011165408.51d4f413@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 11 Oct 2009 16:54:08 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > I'm not so sure. In fact there are some quite umm interesting
> > > questions about this code, and some of them are shared with other
> > > modules too.
> > > 
> > > Consider the following sequence
> > > 
> > > 		CPU1				CPU2
> > > 	register_chrdev
> > > 		ok
> > > 						open device
> > > 						takes lock
> > 
> > 
> > but open does not take the BKL, so the BKL is not protecting you at
> > all against this..
> 
> But module load/unload does

it does?

looking at the code.... so far failing to find where.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
