From: Matthew Wilcox <willy@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 12:39:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227123906.GB25779@parcelfarce.linux.theplanet.co.uk>
References: <1077842444.2662.123.camel@mulgrave> <20040227005601.GA6127@one-eyed-alien.net> <20040227010411.GB819@phunnypharm.org> <1077868581.4443.0.camel@laptop.fenrus.com> <20040227123009.GD4019@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61123 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262693AbUB0MjI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 07:39:08 -0500
Content-Disposition: inline
In-Reply-To: <20040227123009.GD4019@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Arjan van de Ven <arjanv@redhat.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 07:30:09AM -0500, Ben Collins wrote:
> On Fri, Feb 27, 2004 at 08:56:22AM +0100, Arjan van de Ven wrote:
> > surely everyone is using cdrecord -dev=/dev/scd5  by now and not the 
> > host:bus:dev crap...
> 
> scsidev: '/dev/sg1'
> devname: '/dev/sg1'
> scsibus: -2 target: -2 lun: -2
> Warning: Open by 'devname' is unintentional and not supported.

Yeah, we need to patch that warning out of the debian cdrecord packages.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
