From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/7] Improvements, clean-ups, and fixes to target and LUN
 lifecycle
Date: Mon, 10 Aug 2009 11:07:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101044230.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44293 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755032AbZHJPHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 11:07:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

These patches are revised and simplified versions of work posted
before.  They are intended not primarily as fixes for reported bugs but
rather as general clean-ups and improvements; as such I would expect
them to be held in scsi-misc until the next merge window (or maybe the
one after next, since the next one is getting close).

Unlike the earlier patch series, these do not cause any semantic
changes in behavior -- unless you consider elimination of various
use-before-initialize, use-after-free, and memory-leak bugs to be
semantic changes.  :-)

Briefly, the changes implemented by this series are:

	1/7: Merge scsi_target_reap_usercontext with scsi_target_reap.
	2/7: Make starget->reap_ref count the number of underlying
		devices.
	3/7: Add an STARGET_NEW state for use before 
		hostt->target_alloc has been called.
	4/7: Fix miscellaneous bugs and infelicities in the
		target-handling code.
	5/7: Add extra flags to scsi_device to keep track of which
		parts have been constructed.
	6/7: Fix miscellaneous bugs in the device-handling code.
	7/7: Minor improvements and clean-ups for that target- and
		device-handling code.

Alan Stern

