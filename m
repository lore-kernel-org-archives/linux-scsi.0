From: Matthew Wilcox <willy@debian.org>
Subject: Remove 53c7,8xx driver?
Date: Fri, 7 Feb 2003 13:39:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030207133923.M32277@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from willy by www.linux.org.uk with local (Exim 3.33 #5)
	id 18h8ix-0007l0-00
	for linux-scsi@vger.kernel.org; Fri, 07 Feb 2003 13:39:23 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Drew Eckhardt's 53c7,8xx driver seems to be unmaintained:

 - #error for conversion to DMA-mapping.txt
 - still uses cli()
 - still uses pci_find_device()
 - still uses ->abort() and ->reset()

Is it time to put it out of its misery?

Are there any devices this driver supports which are not supported by
one (or more ;-) of:

 - 53c700
 - 53c7xx
 - NCR_D700
 - lasi700
 - ncr53c8xx
 - sym53c8xx
 - sym53c8xx_2
 - sim710
 - zalon

As it stands, it seems to only support the 810, 815, 820 & 825 chips,
so I really think it should be removed.  But maybe I misread the driver;
what do you think?

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
