From: "Kenneth D. Merry" <ken@kdm.org>
Subject: Re: sym2 2.1.18k
Date: Mon, 13 Sep 2004 16:16:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913221641.GA18854@nargothrond.kdm.org>
References: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk> <m38ybdlur2.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nargothrond.kdm.org ([70.56.43.81]:22728 "EHLO
	nargothrond.kdm.org") by vger.kernel.org with ESMTP id S269006AbUIMWQr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 18:16:47 -0400
Content-Disposition: inline
In-Reply-To: <m38ybdlur2.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, Matthias Andree <ma@dt.e-technik.uni-dortmund.de>

On Mon, Sep 13, 2004 at 23:33:05 +0200, Matthias Andree wrote:
> Matthew Wilcox <willy@debian.org> writes:
> 
> > 2.1.18k:
> >  - Relicence from dual BSD/GPL to pure GPL
> 
> Urgh. There was a time when the driver was shared among deveral OSs,
> among them FreeBSD. The BSD world ain't gonna like this for practical
> reasons, the consequence is that they'll either stop merging patches
> from Linux or remove the sym driver from their GENERIC kernels if they
> want your patches.

True, the BSD world likely won't be sharing code after this change.

> Of course, he who writes the code gets to determine the license, hence
> no plea to revert this change, but I'd like to know why this change has
> been made.

I would also like to hear why you made this change.

In addition, you're not the only author of the code.  You really should get
permission from all other copyright holders on the code before changing the
license.

Ken
-- 
Kenneth Merry
ken@kdm.org
