From: Matthew Wilcox <willy@debian.org>
Subject: Re: sym2 2.1.18k
Date: Tue, 14 Sep 2004 01:34:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914003425.GW642@parcelfarce.linux.theplanet.co.uk>
References: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk> <m38ybdlur2.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23266 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269087AbUINAea
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 20:34:30 -0400
Content-Disposition: inline
In-Reply-To: <m38ybdlur2.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Mon, Sep 13, 2004 at 11:33:05PM +0200, Matthias Andree wrote:
> Urgh. There was a time when the driver was shared among deveral OSs,
> among them FreeBSD. The BSD world ain't gonna like this for practical
> reasons, the consequence is that they'll either stop merging patches
> from Linux or remove the sym driver from their GENERIC kernels if they
> want your patches.

They already aren't using it.  I went and trawled their CVS trees for any
bugfixes they might have done to the driver since Gerard went missing.
FreeBSD is using 1.6.5 (ie the driver we removed shortly before 2.6).
NextBSD and OpenBSD have their own driver (siop).

Given that, I don't see the benefit to retaining BSD licence
compatibility.  In addition, retaining dual BSD licencing allows others
to take this driver and use it in proprietary OSes.  I don't like people
being able to take without giving back.

Now, if there's actual real interest from the BSD camps in using this
driver, let's hear it, and I'll revert this change.  But keeping the
BSD licence on it at this point looks like no benefit and only liability.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
