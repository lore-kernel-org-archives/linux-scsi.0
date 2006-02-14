From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] schedule the SCSI qlogicfc driver for removal
Date: Tue, 14 Feb 2006 17:43:09 +0000
Message-ID: <20060214174308.GA25817@infradead.org>
References: <1130186927.6831.23.camel@localhost.localdomain> <20051024141646.6265c0da.akpm@osdl.org> <20051027152637.GC7889@plap.qlogic.org> <20051027190227.GA16211@infradead.org> <20051027215313.GB7889@plap.qlogic.org> <20051028225155.GA13958@infradead.org> <20051028230303.GI15018@plap.qlogic.org> <1130542543.23729.160.camel@localhost.localdomain> <20060204225801.GD4528@stusta.de> <20060214001409.GA17604@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422705AbWBNRn0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060214001409.GA17604@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Badari Pulavarty <pbadari@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2006 at 01:14:09AM +0100, Adrian Bunk wrote:
> As usual, there isn't much feedback regarding problems with one driver 
> from people using an obsolete driver for the same hardware.
> 
> So schedule the SCSI qlogicfc driver for removal and let the 
> flames^Wfeedback begin...

The driver has been deprecatedd since long before the official deprecation
mechanisms existed.  It'll go away for 2.6.17.
