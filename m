From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Wed, 31 Mar 2004 03:29:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403310329.17654.andrex@alumni.utexas.net>
References: <20040327161034.GA9963@twibble.org> <200403282303.02146.andrex@alumni.utexas.net> <20040330035115.GA3680@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:17040 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261832AbUCaI3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 03:29:18 -0500
In-Reply-To: <20040330035115.GA3680@twibble.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

> So you could wait for 2.6.5-rc3/2.6.5 to be released, upgrade to
> 2.6.5-rc3-bkx (where bkx is a bk snapshot with x >=2), or go back to the
> kernel you were using previously but copy the drivers/scsi/dc395x.c and
> drivers/scsi/dc395x.h from the 2.6.5-rc2 kernel into it.

Good news: my drive works properly now in 2.6.5-rc3.  "sg_to_virt failed" 
messages are gone and the drive operates normally.  Unfortunately, my nvidia 
driver won't compile in that kernel...

FYI, copying dc395x.{c,h} from 2.6.5-rc3 into 2.6.3 source didn't work.  The 
driver built okay, but at insertion time I got error messages about 
unresolved symbols.

Anyway, it looks like you've corrected the CD drive problem.  Thanks.  Now I 
just hope the nvidia problem gets resolved by the time 2.6.5 is released.

Andrew.
