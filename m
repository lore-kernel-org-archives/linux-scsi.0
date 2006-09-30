From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: SCSI tape block size
Date: Sat, 30 Sep 2006 22:52:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0609302243120.3656@poirot.grange>
References: <200609241605.32327.johna@onevista.com>
 <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
 <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:31894 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751966AbWI3UwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 16:52:01 -0400
In-Reply-To: <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Thu, 28 Sep 2006, Kai Makisara wrote:

> Both 1 and 2 are needed for 1 MB block size. max_sectors_kb for tapes is 
> not visible in /sys.

Kai, as st maintainer, you surely know - on my tape HP C1533A I cannot 
seem to set up any block size other than 1 byte... Is it __really__ 1 byte 
or is it just some fixed block size that the drive doesn't report and 
cannot change? And it means I cannot test setting of different block 
sizes? I have a (unconnected ATM) slightly newer C1555D, wonder if that 
could use different block sizes?...

1 byte I see in "mt status" and setting anything else with "mt setblk" 
causes "st0: Incorrect block size."

Thanks
Guennadi
---
Guennadi Liakhovetski
