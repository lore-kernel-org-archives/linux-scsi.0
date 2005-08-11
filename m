From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 15:46:49 +0100
Message-ID: <20050811144649.GA28067@parcelfarce.linux.theplanet.co.uk>
References: <1123768768.5062.1.camel@mulgrave> <OFDD993463.B29B392A-ONC125705A.004F39C4-C125705A.004FE950@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38317 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S1751060AbVHKOoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 10:44:10 -0400
Content-Disposition: inline
In-Reply-To: <OFDD993463.B29B392A-ONC125705A.004F39C4-C125705A.004FE950@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 11, 2005 at 04:32:51PM +0200, Harald Seipp wrote:
> James Bottomley wrote on 11.08.2005 15:59:27:
> > On Thu, 2005-08-11 at 12:09 +0200, Harald Seipp wrote:
> > > I assume this is a bug? How can I prevent that behavior? Can I easily
> query
> > > if a device on "h b t l" is mounted to work-around?
> >
> > No, it's expected behaviour.  The mount keeps a reference to the old
> > device node so it can't be reused.
> Ok - but shouldn't the behavior that devices that have mounted partitions
> can be removed be considered as a bug?
> Linux 2.4 SCSI Subsystem Howto, proc interface: "....The removal will fail
> if the device is busy (e.g. if a file system on the device is mounted)."

The trouble is that users can surprise-remove drives (eg USB memory) and
there's nothing we can do about it.  So the SCSI subsystem is designed
to cope as best it can with such a scenario rather than trying to forbid
in software an action that already took place in hardware.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
