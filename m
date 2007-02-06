From: David Miller <davem@davemloft.net>
Subject: Re: [Bugme-new] [Bug 7951] New: ESP DMA error
Date: Tue, 06 Feb 2007 13:33:46 -0800 (PST)
Message-ID: <20070206.133346.54189524.davem@davemloft.net>
References: <200702061754.l16HsxR6031831@fire-2.osdl.org>
	<20070206132917.ccd7348b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070206132917.ccd7348b.akpm@linux-foundation.org>
Sender: sparclinux-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, mt1@systella.fr, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Feb 2007 13:29:17 -0800

> Apparently a recent regression.

It's on sparc32 (and SMP on top of that, scary) which is only lightly
maintained, so it could be anything.  It would be interesting if
running a uniprocessor kernel made the problem go away.

I would only be concerned at the scsi layer level if you see a sparc64
report like this.
