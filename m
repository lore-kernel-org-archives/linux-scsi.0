From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 18:05:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210280005.g9S057Q14567@localhost.localdomain>
References: <aebr@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA12186
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 16:05:15 -0800
In-Reply-To: Message from Andries Brouwer <aebr@win.tue.nl>
   of "Sun, 27 Oct 2002 23:10:07 +0100." <20021027221007.GA28417@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

If the return type will be ignored by most applications, I don't see what the 
problem is.

I'm all for ripping the C/H/S rubbish out of the kernel, just give me the 
patches when you have them.  Until that time, we need the changes Christoph 
has made now to solve a layering violation in SCSI.  And, since I never want 
to see the bios_param stuff again, I'm not going to put in code (like an 
obviously wrong truncation) that would attract attention in a large block size 
audit of the SCSI subsystem.  The sector_div is an obviously correct thing to 
do for a sector_t quantity, so it's staying.

James




