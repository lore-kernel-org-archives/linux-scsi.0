From: Matthew Wilcox <willy@debian.org>
Subject: Re: SCSI HBA in wrong order
Date: Fri, 9 Jul 2004 17:43:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040709164359.GF5889@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.58.0407091027580.12759@rray1.jam.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28568 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265093AbUGIQoC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 12:44:02 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0407091027580.12759@rray1.jam.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: raray@jam.rr.com
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 09, 2004 at 10:29:34AM -0500, raray@jam.rr.com wrote:
> I have 3 Compaq Proliant ML370 servers with RedHat 9.0 and 2.4.23 kernel.
> Each of these machines has an optical jukebox with 6 drives attached.
> The 2 internal SCSI drives are attached to the HBA built into the system
> board.
> The jukebox is attached to a LSIU40HVD HBA.
> Linux assigns the built in HBAs as scsi0 and scsi1 and assigns the
> LSIU40HVD as scsi2 and scsi3.
> I upgraded one server to Fedora Core 2 with 2.6.6 kernel.
> Now Linux assigns the built in HBAs as scsi2 and scsi3 and assigns the
> LSIU40HVD as scsi0 and scsi1.
> This really screws things up. Anybody got any ideas how to fix this?

There is no way to fix this.  Supporting hotplug means that the sym2
driver is told about the HBAs in PCI bus scan order.  I assume all your
HBAs are driven by the sym2 driver?  If not, you could load the modules
in the other order to get the internal HBAs before the external HBAs.

In any case, this is a Red Hat kernel, you should be complaining to them,
not here.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
