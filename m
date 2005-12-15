From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Wed, 14 Dec 2005 18:14:33 -0600
Message-ID: <43A0B569.3080708@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <20051214012856.GA185272@sgi.com> <1134536377.3133.13.camel@mulgrave> <20051214235659.GB44861@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.25]:23749 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S932532AbVLOAOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 19:14:47 -0500
In-Reply-To: <20051214235659.GB44861@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org



Jeremy Higdon wrote:
...snip...
>> My primary concern in all of this is that the write posting flush was
>> incorrectly removed.  In this case, a UP VISWS should still show the
>> error (now we've established that it's posting even in the PIO case).
>> If it doesn't, I'll be happy with a VISWS specific fix.
> 
> I'm a little surprised that the UP VisWS is showing the problem.  It
> looks like it might be reordering writes from the same CPU, though that
> seems really unlikely.  I think more debugging of the VisWS is in order
> before we can draw any conclustions.
> 
...snip...

I don't think it has yet been determined that UP is exhibiting the
problem.  I haven't seen a reply after James requested that the
test be rerun using UP kernel.

(I think it was inferred that the VISWS in question was MP but
I didn't see it explicitely stated.)

Mike
