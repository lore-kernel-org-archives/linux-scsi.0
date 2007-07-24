From: David Miller <davem@davemloft.net>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Tue, 24 Jul 2007 14:48:44 -0700 (PDT)
Message-ID: <20070724.144844.74557601.davem@davemloft.net>
References: <Pine.LNX.4.61.0707241758020.17959@mtfhpc.demon.co.uk>
	<20070724.124304.51855385.davem@davemloft.net>
	<Pine.LNX.4.61.0707242116370.17959@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbXGXVso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 17:48:44 -0400
In-Reply-To: <Pine.LNX.4.61.0707242116370.17959@mtfhpc.demon.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark@mtfhpc.demon.co.uk
Cc: James.Bottomley@SteelEye.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Tue, 24 Jul 2007 22:28:42 +0100 (BST)

> I thought I rememberd seeing somthing about memset.
> 
> Having changed the memset code, I have found that the ESP scsi BUS 
> Timeout can be reverted back to 250ms. Both SCSI drivers are now working 
> properly both built in and as modules.

Thanks Mark.

What I'll do is merge in the sparc32 memset() fix then, once that is
in, send James a patch to revert the ESP bus timeout back down to 250.
