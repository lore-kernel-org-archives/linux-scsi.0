From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] retry with missing data for INQUIRY
Date: Fri, 5 Dec 2008 10:14:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812051014010.2588-100000@iolanthe.rowland.org>
References: <20081205112146Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35001 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754010AbYLEPOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 10:14:46 -0500
In-Reply-To: <20081205112146Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: orjan.nordlund@gmail.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, 5 Dec 2008, FUJITA Tomonori wrote:

> This depends on the following patch, adds residual argument to
> scsi_execute and scsi_execute_req:
> 
> http://marc.info/?l=linux-scsi&m=122836830920741&w=2
> 
> 
> With the above patch, we can fix the Thecus N2050 storage device
> problem more cleanly, which was solved by Alan's patch:
> 
> http://marc.info/?l=linux-scsi&m=122513368301598&w=2

This looks great!  Thanks for doing the work.

Alan Stern

