From: Alan Stern <stern@rowland.harvard.edu>
Subject: Submit commit 3dea642afd for 2.6.38.stable?
Date: Mon, 16 May 2011 16:45:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1105161626070.2013-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55548 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752314Ab1EPUpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2011 16:45:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Luben Tuikov <ltuikov@yahoo.com>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

James:

Your commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a ([SCSI] Revert
"[SCSI] Retrieve the Caching mode page") hasn't been submitted for the
2.6.38 stable tree.  More people are now getting hit with the
underlying problem; see

	https://bugzilla.kernel.org/show_bug.cgi?id=35042

Do you want to queue your commit to the stable tree, or do you prefer
to wait until the proper repair patch:

	http://marc.info/?l=linux-scsi&m=130089710431684&w=2

has been merged so it can go into the stable tree instead?

Alan Stern

P.S.: As of now, the scsi-next tree doesn't show any signs of
reinstating Luben's original commit together with my repair patch.  
Does this mean you intend to forget about the original "Retrieve the
Caching mode page" change, or do you intend to merge them for 2.6.41?)

