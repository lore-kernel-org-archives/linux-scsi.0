From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 13:13:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030718131352.A26546@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org> <20030718122304.A23013@infradead.org> <20030718121202.GC6520@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030718121202.GC6520@marowsky-bree.de>; from lmb@suse.de on Fri, Jul 18, 2003 at 02:12:02PM +0200
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 18, 2003 at 02:12:02PM +0200, Lars Marowsky-Bree wrote:
> Please come and attend the multipath session at the Kernel Summit and/or
> the Ottawa Linux Symposium next week to learn why this is a bad idea and
> how it can be done better -> http://www.linuxsymposium.org/

-ENOTIME :)

> However, for backwards compatibility with 2.4, I assume it might still
> be needed in 2.5/2.6, but _only_ with the clear intend of phasing it out
> within 2.6 and dropping it in 2.7.
> 
> QLogic is reasonably good already in that it can be disabled via a
> module parameter (ql2xfailover=0), allowing the higher level solutions
> to operate.

Given that this module never was in 2.4 I don't see clear backwards
compatiblity problems..
