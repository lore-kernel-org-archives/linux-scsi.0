From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
Date: Fri, 15 Feb 2008 08:54:56 -0700
Message-ID: <20080215155456.GE7657@parisc-linux.org>
References: <20080212234928.GA13892@havoc.gtf.org> <1203024822.3158.29.camel@localhost.localdomain> <47B5B374.2080403@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60331 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYBOPy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2008 10:54:58 -0500
Content-Disposition: inline
In-Reply-To: <47B5B374.2080403@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Jiri Slaby <jirislaby@gmail.com>

On Fri, Feb 15, 2008 at 10:44:52AM -0500, Jeff Garzik wrote:
> I kept those array for one reason:  you need it to preserve the existing 
> in-driver PCI device sort.

Just get rid of it.  I got rid of it for sym2 during 2.5 and very few
people have complained.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
