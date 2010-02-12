From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/5] Miscellaneous bug fixes
Date: Fri, 12 Feb 2010 12:13:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121207460.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35471 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757145Ab0BLRNV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:13:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

The following series of five patches fixes various bugs in the SCSI 
core, mostly on error pathways or involving unlikely races.

Alan Stern

