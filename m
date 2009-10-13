From: Alan Stern <stern@rowland.harvard.edu>
Subject: Reaping targets in_interrupt
Date: Tue, 13 Oct 2009 12:56:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910131252420.3169-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54658 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753751AbZJMQ5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 12:57:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

Under what circumstances would a driver want to reap a target while in 
interrupt context?

My best guess would be on a bus where the host driver gets asynchronous 
notifications of target hotplug and hot-unplug events.  But even then 
you couldn't reap the target without first unregistering all the 
devices beneath the target, which has to be done in process context.  
So that doesn't answer the question.

Can you explain the ideas behind all this?

Alan Stern

