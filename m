From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: Problems with MSI-X on ia64
Date: Fri, 27 Jan 2006 09:34:13 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF10B8ABBD0@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-ia64-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Grundler, Grant G" <grant.grundler@hp.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> cciss/c2d0:
> > 
> > And this is where we hang, when enabling interrupts in the driver.
> 
> Can you try 2.6.15, or possibly 2.6.16-rc1-mm3?
> 
That's the next step. Unfortunately the system is at another site so
there is latency in the process.

mikem
