From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Mon, 09 Dec 2002 16:53:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <203630000.1039477998@aslan.btc.adaptec.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

The latest installments of the Aic7xxx (Legacy -> U160) and Aic79xx (U320)
driver are now available here:

http://people.FreeBSD.org/~gibbs/linux/RPM  # RPMs for popular distributions
http://people.FreeBSD.org/~gibbs/linux/DUD  # Driver Update Diskettes
http://people.FreeBSD.org/~gibbs/linux/SRC  # Source tarballs for 2.4.X and 
					      2.5.x relative to today's
					      bk trees.

When compared to the versions of the driver currently embedded in either
the 2.4.X or the 2.5.X (at least for the U160 driver), the fixes and changes
are so numerous as to make it difficult to name them all.  Highlights
include:

o Auto-detection and fallback to PIO for broken VIA chipsets with byte
  merging enabled.
o Domain Validation
o Support for the 2.5.X dynamic queue depth facility
o Support for the 2.5.X slave alloc/configure/destroy API
o The shutdown hook has been disabled on 2.5.X to avoid a panic
  on shutdown since the hooks are called to early in that kernel series.
  I'm still working on an alternative.  In the mean time, aic785X based
  cards may not play nice with the Adaptec BIOS on a warm reboot.
o Even more workarounds for deadlocks in the 2.4.X SCSI error recovery code.
  We now "spoon feed" transactions that have failure codes back to the
  mid-layer so as to avoid the stack blow-out from recursion that can occur
  in scsi_queue_next_request.

--
Justin

