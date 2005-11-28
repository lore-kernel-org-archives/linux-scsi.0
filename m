From: James.Smart@Emulex.Com
Subject: RE: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Mon, 28 Nov 2005 16:16:33 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23203 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932124AbVK1VQl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:16:41 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org


> So you this storage vendor please provide us this test case 
> as a start?

Basic test case:
 - start load on the fc disks
 - run sg_reset -b /dev/sgX or sg_reset -d /dev/sgX

> That beeing said I mentioned that we need to do SG-based 
> resets via the
> EH thread aswell.  As Emulex apparently cares about the above 
> case would
> you mind implementing it?

Well - we would prefer the vendor test the system as it should behave
in normal circumstances rather than test-suite-derived conditions.

Yes, we will sign up for this. However, we have several items on our
plate so we won't be on this quickly. I would hope there would be no
issue with accepting the patch as is and backing out the relatived code
as part of the eventual patch.  We'll also be contacting the SG maintainer
to get his/her thoughts.

-- james

