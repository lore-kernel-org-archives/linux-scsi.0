From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Qlogic ISP 1020
Date: Tue, 23 Mar 2004 06:29:12 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040323062912.B29405@infradead.org>
References: <1080004793.5848.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:34053 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262109AbUCWG3O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 01:29:14 -0500
Content-Disposition: inline
In-Reply-To: <1080004793.5848.34.camel@localhost>; from jtlayton@poochiereds.net on Mon, Mar 22, 2004 at 08:19:54PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeff Layton <jtlayton@poochiereds.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2004 at 08:19:54PM -0500, Jeff Layton wrote:
> I recently acquired a new tape drive with a HVD SCSI interface. I also
> got a QLogic ISP 1020 based SCSI card to drive it. Unfortunately, I seem
> to be having some problems with the qlogicisp driver in the 2.6 kernel.
> Occasionally I get a SCSI error, and it takes the tape drive offline,
> since the qlogicisp driver doesn't have proper error handling for 2.6.
> 
> Is there a maintainer for the 2.6 qlogicisp driver? I saw that Christoph
> Hellwig had posted part of a patch to add support for the 1020 and 1040
> cards to the qla1280 driver. Has this been completed yet, and if so is
> there a place I could download the complete patch? 

https://verein.lst.de/~hch/qla1280-isp1040.diff.bz2 has my current patch.

So far I only kno it works with 1040B's on SGI Origins.   If you want to
give it a try apply the patch and make sure you have the qla1280 but not the
qlogicisp driver in the kernel.

I'll try to split the patch into reasoable chunk soon and feed it to Jes.
