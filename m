From: Matthew Wilcox <willy@debian.org>
Subject: drivers/scsi/Kconfig
Date: Fri, 30 May 2003 17:38:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030530163817.GM28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25239 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263781AbTE3QY5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 12:24:57 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: sparclinux@vger.kernel.org, ultralinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org


Hello architecture maintainers who weren't using drivers/scsi/Kconfig.
This patch which is 70k+ and too big to post deletes over a thousand lines
of code (ok, mainly duplicated helptext):

 arch/m68k/Kconfig    |  412 ---------------------------------
 arch/sparc/Kconfig   |  225 ------------------
 arch/sparc64/Kconfig |  635 ---------------------------------------------------
 drivers/scsi/Kconfig |  261 ++++++++++++--------
 4 files changed, 159 insertions(+), 1374 deletions(-)

http://ftp.linux.org.uk/pub/linux/willy/patches/scsi-kconfig.diff

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
