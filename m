From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 11:43:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122194307.GH2611@beaverton.ibm.com>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com> <4010034A.3040903@us.ibm.com> <1074792163.2149.12.camel@mulgrave> <4010096D.4030205@us.ibm.com> <1074793813.2149.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:31180 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266365AbUAVTje
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 14:39:34 -0500
Content-Disposition: inline
In-Reply-To: <1074793813.2149.32.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Brian King <brking@us.ibm.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Thu, 2004-01-22 at 12:33, Brian King wrote:
> > I agree that this is a solution as well (requires more code), but
> > then sysfs will show the device as a different device type, which
> > I would think might be confusing.
> 
> Isn't there a volume manager type ... don't have access to the standards
> at the moment, but I vaguely remember this.  That is essentially what
> you're doing isn't it? discs that are part of an array?
> 

Trying to understand the scope of support for the LLDD. While just
changing the device_type would be a small change, intercepting future
inquiry commands to ensure all future device_types returned this new
value would be larger. 

Is your comment to change the device type to stop binding also include
this intercept capability.

It would seem that if in the future we would want some user space binding
control that adding this LLDD device_type modification would be more
code to clean out vs just not setting a no bind bit anymore.

-andmike
--
Michael Anderson
andmike@us.ibm.com

