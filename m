From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Mon, 5 Mar 2007 17:22:30 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0703051714550.4419-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60564 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751443AbXCEWWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2007 17:22:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Doug:

I haven't gotten any feedback on this patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=117198739722640&w=2

Pending Mike's efforts to get a completely realistic estimate for the
maximum allowable size of a transfer request, is there any reason not to
accept the patch in its original form?  Will Mike's other recent changes
affect it at all?

Alan Stern

