From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Mon, 15 Dec 2008 11:13:50 -0600
Message-ID: <1229361230.3293.45.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0811191652570.17161@fi-hi32-dhcp068123.emea.nsn-net.net>
	 <49468C4A.2040508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49616 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbYLORNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 12:13:40 -0500
In-Reply-To: <49468C4A.2040508@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>, linux-scsi@vger.kernel.org, matthew@wil.cx

On Mon, 2008-12-15 at 10:56 -0600, Mike Christie wrote:
> Koskinen Aaro (NSN - FI/Helsinki) wrote:
> > Make the sym53c8xx_2 driver slave_alloc/destroy less unsafe. References
> > to the destroyed LCB are cleared from the target structure (instead of
> > leaving a dangling pointer), and when the last LCB for the target is
> > destroyed the reference to the upper layer target data is cleared. The
> > host lock is used to prevent a race with the interrupt handler. Also
> > user commands are prevented for targets with all LCBs destroyed.
> > 
> > Signed-off-by: aaro.koskinen@nsn.com
> 
> 
> Same signed off line issue. Should be Signed-off-by: Aaro Koskinen 
> <aaro.koskinen@nsn.com>.

Right, thanks!

> There were also some whitespace issues, but merging it with git-am 
> --whitespace=fix fixed them up.

You can pick these up by running the patch through scripts/checkpatch.pl

Matthew, Are you still maintaining this driver, or is it going
unmaintained and it's up to me to vet these patches?

James


