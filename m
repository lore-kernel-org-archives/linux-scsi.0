From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Wed, 14 Dec 2005 17:13:41 -0800
Message-ID: <20051215011341.GA192359@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <20051214012856.GA185272@sgi.com> <1134536377.3133.13.camel@mulgrave> <20051214235659.GB44861@sgi.com> <43A0B569.3080708@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:7589 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S964789AbVLOBNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 20:13:54 -0500
Content-Disposition: inline
In-Reply-To: <43A0B569.3080708@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Wed, Dec 14, 2005 at 06:14:33PM -0600, Michael Reed wrote:
> 
> 
> Jeremy Higdon wrote:
> ...snip...
> >> My primary concern in all of this is that the write posting flush was
> >> incorrectly removed.  In this case, a UP VISWS should still show the
> >> error (now we've established that it's posting even in the PIO case).
> >> If it doesn't, I'll be happy with a VISWS specific fix.
> > 
> > I'm a little surprised that the UP VisWS is showing the problem.  It
> > looks like it might be reordering writes from the same CPU, though that
> > seems really unlikely.  I think more debugging of the VisWS is in order
> > before we can draw any conclustions.
> > 
> ...snip...
> 
> I don't think it has yet been determined that UP is exhibiting the
> problem.  I haven't seen a reply after James requested that the
> test be rerun using UP kernel.
> 
> (I think it was inferred that the VISWS in question was MP but
> I didn't see it explicitely stated.)
> 
> Mike


In a private email, Michael Joosten told me that he was running an SMP
kernel on a single processor 320.

jeremy
