From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Fwd: Re: [Scst-devel] linuxcon 2010...
Date: Tue, 17 Aug 2010 15:30:40 -0500
Message-ID: <1282077040.16098.47.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab0HQUav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 16:30:51 -0400
In-Reply-To: <4C69653E.6050808@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 20:20 +0400, Vladislav Bolkhovitin wrote:
> Hello James,
> 
> Could you comment rumors that decision about future Linux SCSI target 
> subsystem is done as well as other related rumors:

If this is related to LSF, the notes on the I/O track are here:

http://lwn.net/Articles/400491/

> 1. What don't you like in the transition path for users from STGT to 
> SCST, which I proposed:
> 
>   - The only people which would be affected by replacing of STGT by SCST
> would be users of ibmvstgt. Other STGT users would not notice it at all. 
> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST, 
> the update for its users would be just writing of a simple scstadmin's 
> config file.
> 
>   - STGT doesn't have backend drivers, which SCST doesn't have, so
> there's nothing to worry here. At max, AIO support should be added to 
> fileio_tgt.
> 
>   - STGT user space targets can use SCST backend via scst_local module.
> Scst_local module is ready and work very well.
> 
> The result would be very clear without any obsolete mess.

So does that get us up to being a drop in replacement?  I think you're
saying that even with all of this, at least the VSCSI part will need
updating, so the answer seems to be "no".

> 2. Don't you like something in the sysfs interface SCST has?

I don't think so ... from a cursory glance it looks functional.

> 3. I have heard you said "Vlad wasn't comfortable in handing up the 
> control to the maintainers ... (this is how kernel.org works)." I have 
> no idea what you meant. I have never been asked about anything like 
> that, so I couldn't say anyhow that I'm not comfortable with anything. 
> Could you clarify that?
> 
> 4. Have you changed your opinion that a driver level multipath is 
> forbidden in Linux and now you think that an iSCSI target with MC/S 
> support is acceptable?

no; I still think MCS is a pointless duplication of multipath that only
works for iSCSI.

James


