From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 13:05:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409161305.02947.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org> <1095362263.16326.12.camel@praka> <20040916125631.1f25dfdb.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:48280 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268265AbUIPUGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 16:06:37 -0400
In-Reply-To: <20040916125631.1f25dfdb.pj@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Thursday, September 16, 2004 12:56 pm, Paul Jackson wrote:
> Andrew Vasquez has been looking at this, via private email with just
> me (no progress yet).  Figured I update the larger list with this much ...

It seems to be failing on one of the accesses to PCI_COMMAND in config space 
in qla2x00_reset_chip().  I'm checking now to see if we're accessing the card 
right after a reset but before the card has finished.  That would cause a 
master abort, the symptom I'm seeing at least.

> I am still seeing the SN2 SCSI QLA failure as I reported yesterday, but
> now against 2.6.9-rc2-mm1.

Me too.

Jesse
