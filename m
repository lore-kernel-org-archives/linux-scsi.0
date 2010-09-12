From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: UltraStar fails detection with "Unsupported sector size 524"
Date: Sun, 12 Sep 2010 19:58:09 +0200
Message-ID: <19597.5297.146253.996923@pilspetsen.it.uu.se>
References: <19597.3653.893156.794645@pilspetsen.it.uu.se>
	<4C8D0ED2.8080005@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:56292 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab0ILR6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2010 13:58:11 -0400
In-Reply-To: <4C8D0ED2.8080005@cmu.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stroucken <mxs@cmu.edu>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-scsi@vger.kernel.org

Michael Stroucken writes:
 > Mikael Pettersson wrote:
 > > I got a bunch of 72G IBM UltraStars that were taken from some
 > > kind of IBM storage server.  The Linux kernel however doesn't
 > > like them, complaining about a non-512 byte sector size:
 > >
 > > According to the datasheets these drives have soft-configurable
 > > sector sizes from 512 up to 528 bytes, but they don't say how
 > > that configuration is done.
 > >
 > > Any ideas on how to reconfigure these drives for 512-byte sectors?
 > >   
 > 
 > Low level format?

How would I do that in Linux?  I assume it requires some
SCSI-specific tool, or perhaps even a vendor-specific one.
