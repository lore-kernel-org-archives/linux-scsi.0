From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Kill off sym1
Date: Tue, 23 Sep 2003 13:07:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923120731.GC13172@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:1664 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263352AbTIWMHc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 08:07:32 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 1A1lx5-0003Sc-KE
	for linux-scsi@vger.kernel.org; Tue, 23 Sep 2003 13:07:31 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 - Remove sym1 driver
 - Remove PCI stuff from sym53c8xx_comm.h
 - Remove PCI stuff from ncr53c8xx.c
 - Remove device_t typedef
 - Remove u_int32 and u_int64
 - Remove first_host and the_template
 - Remove SPARC support (get back to me when someone puts a 720 in a Sparc :-P)

 Makefile         |    1 
 NCR_Q720.c       |    4 
 ncr53c8xx.c      |  155 
 ncr53c8xx.h      |   12 
 sym53c8xx.c      |14543 -------------------------------------------------------
 sym53c8xx.h      |   82 
 sym53c8xx_comm.h |  666 --
 sym53c8xx_defs.h |   52 
 zalon.c          |    4 
 9 files changed, 76 insertions(+), 15443 deletions(-)

http://ftp.linux.org.uk/pub/linux/willy/patches/sym1.diff

for the full 420k patch.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
