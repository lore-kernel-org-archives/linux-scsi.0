From: Alan Stern <stern@rowland.harvard.edu>
Subject: Suspending SCSI devices and buses
Date: Wed, 18 Aug 2004 16:36:53 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408181632410.1138-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:32516 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267657AbUHRUgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 16:36:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

How does a host driver tell the SCSI core that an adapter is being 
suspended (and hence the core needs to suspend all the devices attached to 
that adapter)?  Ditto for resume.

There doesn't appear to be any way to do it.  The scsi_bus_type and 
various driver structures don't contain a "suspend" entry.

Alan Stern

