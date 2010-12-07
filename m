From: tomm <tommlkml@gmail.com>
Subject: Re: mvsas errors in 2.6.36
Date: Tue, 7 Dec 2010 19:45:26 +0000 (UTC)
Message-ID: <loom.20101207T203638-996@post.gmane.org>
References: <201010290650.32892.thomas@fjellstrom.ca> <201010310911.45738.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43087 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0LGTuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Dec 2010 14:50:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1PQ3Y5-0000sc-CC
	for linux-scsi@vger.kernel.org; Tue, 07 Dec 2010 20:50:05 +0100
Received: from c-24-8-176-90.hsd1.co.comcast.net ([24.8.176.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 07 Dec 2010 20:50:05 +0100
Received: from tommlkml by c-24-8-176-90.hsd1.co.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 07 Dec 2010 20:50:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Thomas Fjellstrom <thomas <at> fjellstrom.ca> writes:

[snip]
> > The card is a AOC-SASLP-MV8

Been following this discussion and wondering if you have
finally found a solution to this problem?

Also, have you considered this might be a heat problem with
the card?  That particular Supermicro card as a large heat
sink on the Marvell chip and during operation I've noticed
it gets quite hot.  Perhaps you can try running a fan over
the card and re-running your tests to rule this out.

-tom

