From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] dtc: Coding police and printk levels
Date: Fri, 22 Jun 2007 20:28:02 +0100
Message-ID: <20070622202802.16118c92@the-village.bc.nu>
References: <20070622142629.52519e47@the-village.bc.nu>
	<20070622180005.GF7535@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60535 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750945AbXFVTWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 15:22:22 -0400
In-Reply-To: <20070622180005.GF7535@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Fri, 22 Jun 2007 11:00:06 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> On Fri, Jun 22, 2007 at 02:26:29PM +0100, Alan Cox wrote:
> > @@ -244,7 +242,7 @@
> >  					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
> >  						addr = bases[current_base].address;
> >  #if (DTCDEBUG & DTCDEBUG_INIT)
> > -						printk("scsi-dtc : detected board.\n");
> > +						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
> 
> I think you meant KERN_DEBUG ?

Thanks - thats a path thats not compiled and I missed that. Will fix it.
