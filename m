From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 19:59:32 +0000
Message-ID: <20041130195932.GA29035@parcelfarce.linux.theplanet.co.uk>
References: <200412010331.VAA21676@catalyst.austin.ibm.com> <1101843791.1779.1048.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:44004 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262290AbUK3T7j
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 14:59:39 -0500
Content-Disposition: inline
In-Reply-To: <1101843791.1779.1048.camel@rebel.corp.whenu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard F. Rebel" <rrebel@whenu.com>
Cc: kwhite@austin.ibm.com, linux-scsi@vger.kernel.org

On Tue, Nov 30, 2004 at 02:43:11PM -0500, Richard F. Rebel wrote:
> Earlier someone responded to the tune that I needed to change the PCI
> boot order, and unless the bios allows me to change that,  I have to
> move the cards around in the chassis.  I have a cage monkey trying that
> now.

I think you misunderstood.  The PCI ID is determined by how the PCI
slot is wired up -- there's nothing the BIOS can do to affect that.

[hmm.  if you're particularly perverse, i suppose you could route the
select lines through a chip that the BIOS could reprogram ... never
seen it done though.]

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
