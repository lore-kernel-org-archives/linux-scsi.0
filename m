From: Christoph Hellwig <hch@lst.de>
Subject: State of NCR53c7xx based drivers
Date: Sat, 22 Nov 2003 12:38:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031122113834.GA8098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61366 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262196AbTKVLio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 06:38:44 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

[and now with the right address for the m68k list]

Hi folks,

what's the status of the 53c7xx based drivers, namely amiga7xx,
mvme16x and bvme6000?  These are the last ones still using the
old 53x7xx instead of the new 53c700 core which despite the
name also handles 53c710 chips.  As the 53c7xx driver hasn't
been updated to proper locking, error handling and bus mapping
APIs we'd really better get rid of it.  Porting to use 53c700
should be trivial in theory and we already have three nice example
drivers in the tree.

Could anyone who has the hardware try to do a port?  Or are they
actually completely dead (I could imagine that for the vme ones)
in which case we'd better just remove them from tree, as they're
really tiny wrapper only anywa.

As for amgia7xx is there a reason we have four different config
options for this single tiny driver?
