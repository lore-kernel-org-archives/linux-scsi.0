From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Linux [2.6.0-test3/mm1] aic7xxx problems.
Date: Mon, 11 Aug 2003 11:22:22 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2425882704.1060622541@aslan.btc.adaptec.com>
References: <1060543928.887.19.camel@blaze.homeip.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1060543928.887.19.camel@blaze.homeip.net>
Content-Disposition: inline
To: Paul Blazejowski <paulb@blazebox.homeip.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On a side note, the same aic7xxx drivers version 6.2.8 and 6.2.36 works
> with 2.4.21 and 2.4.22-rc1/rc2 series of kernel with above hardware.

I don't think that any of the changes between 6.2.35 and 6.2.36 will
make a difference for you, but you could try upgrading.  The source
files are here:

http://people.FreeBSD.org/~gibbs/linux/SRC/

The console output you've provided makes me think that interrupts are
not working correctly in your system.

--
Justin
