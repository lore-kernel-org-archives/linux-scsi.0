From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: How does a SCSI device gets a target ID?
Date: Wed, 9 Mar 2005 17:29:43 +0000
Message-ID: <20050309172943.GB21986@parcelfarce.linux.theplanet.co.uk>
References: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com> <200503091655.j29Gt2517120@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38088 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262116AbVCIR3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 12:29:47 -0500
Content-Disposition: inline
In-Reply-To: <200503091655.j29Gt2517120@www.watkins-home.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: "'Rajat  Jain, Noida'" <rajatj@noida.hcltech.com>, linux-scsi@vger.kernel.org

On Wed, Mar 09, 2005 at 11:54:57AM -0500, Guy wrote:
> A narrow SCSI bus will support 8 devices.
> A wide SCSI bus will support 16 devices.
> A narrow bus uses 50 pins.
> A wide bus uses 68 pins.

We need a SCSI Wiki for all this kind of information ... maybe Wikipedia?

> There is a standard for auto selecting the SCSI ID.  I have never used this.
> SCAM (SCSI Configures Auto Magically).

I think the SCSI vendors prefer to sell SCA drives rather than SCAM
drives ;-) Drives with the SCA connector have power supplied to them and
their SCSI ID configured automatically depending on which slot they're
plugged into.  If you're doing hotplug SCSI, it's probably with SCA drives.

> Mixing devices with different electrical standards can be tricky.  Some
> can't be mixed.  HVD is not compatible with any other.

And plugging any SE devince onto an LVD bus causes the whole bus to fall
back to SE.  This includes terminators.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
