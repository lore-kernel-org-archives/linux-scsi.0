From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Fri, 13 Aug 2004 09:05:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092351942.26423.17.camel@gaston>
References: <4119611D.60401@optonline.net>
	 <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net>
	 <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston>
	 <1092314892.1755.5.camel@mulgrave> <20040812131457.GB1086@elf.ucw.cz>
	 <1092328173.2184.15.camel@mulgrave> <20040812191120.GA14903@elf.ucw.cz>
	 <1092339247.1755.36.camel@mulgrave>  <20040812202622.GD14556@elf.ucw.cz>
	 <1092342716.2184.56.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:8942 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S268884AbUHLXLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 19:11:07 -0400
In-Reply-To: <1092342716.2184.56.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Pavel Machek <pavel@suse.cz>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

On Fri, 2004-08-13 at 06:31, James Bottomley wrote:
> On Thu, 2004-08-12 at 16:26, Pavel Machek wrote:
> > Yes.
> 
> Well, that makes the suspend and resume functions rather complex. 
> They're not going to be coded simply if we have to save and restore the
> register state of the cards and reinitialise them.  I assume if you had
> to pick three drivers to do this for, that would be aic7xxx, aic79xx and
> sym_2?

It's not simple for some chips, it's simple for others, in lots of
cases, it's just a matter of re-doing the driver init code though.

Ben.


