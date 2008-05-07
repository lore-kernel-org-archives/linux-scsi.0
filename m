From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6.25.1] qla2xxx can't see more than 4 drives
Date: Wed, 7 May 2008 09:59:03 -0700
Message-ID: <20080507165903.GC69102@plap4.local>
References: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net> <20080506135118.GA46493@plap4.qlogic.org> <alpine.DEB.1.10.0805061022120.5741@mtl.rackplans.net> <20080506220826.GI57975@plap4.qlogic.org> <alpine.DEB.1.10.0805071204000.31448@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39767 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYEGQ7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 12:59:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805071204000.31448@mtl.rackplans.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 07 May 2008, Gerhard Mack wrote:

> > You mentioned that the 'BIOS' configuration program recognizes 6
> > devices, have there been any changes made via the BIOS utility to
> > 
> > * assign a hard-loop id?
> > * acquire a loop-id during LIPA?
> > 
> > or any changes above and beyond 'default' settings?  If so, could you
> > 'retrore' default settings within BIOS utility?
> 
> Hmm your right.. it's only showing 4 drives in the BIOS utility.  Don't 
> know why I recall seeing more ealier.
> 
> It's back to default and only showing 4 drives.

Ok, so at least the BIOS and driver views of the topology are
consistent...  The firmware supports up to 126 devices in a FCAL
topology, so there's no HBA limit that is being run into here.

You mentioned that if you remove the originally visible drives, then
the driver/BIOS can see the previously non-visible drives -- perhaps
there is some limitation with the storage enclosure you are using...

Regards,
Andrew Vasquez
