From: Anton Blanchard <anton@samba.org>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: Wed, 29 Sep 2004 01:25:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928152548.GD3373@krispykreme.ozlabs.ibm.com>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com> <20040928145638.GY16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34711 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S267934AbUI1P0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 11:26:37 -0400
Content-Disposition: inline
In-Reply-To: <20040928145638.GY16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

 
> Yes, this looks like the right solution to me.
> 
> Can you tell me what circumstances you see it under, and do you
> successfully negotiate 160MB/s with this patch?

There is a bunch of bad hardware in it, so Im having a bit of trouble
working out exactly what is going on :) I'll look through the logs and
see if I can make sense of them.

Anton
