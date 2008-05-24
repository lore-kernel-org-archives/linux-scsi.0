From: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] SCSI: remove dev->power.power_state from mesh
	driver
Date: Sat, 24 May 2008 20:21:31 +1000
Message-ID: <18487.60459.472964.51725@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.44L0.0803071118040.4398-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYEXKVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 May 2008 06:21:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803071118040.4398-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern writes:

> power.power_state is scheduled for removal.  This patch (as1055)
> removes all uses of that field from the SCSI mesh driver.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Paul Mackerras <paulus@samba.org>
