From: Wakko Warner <wakko@animx.eu.org>
Subject: AIC94xx SAS question.
Date: Mon, 21 Apr 2008 19:19:40 -0400
Message-ID: <20080421231940.GB5656@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:47705 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbYDUXTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 19:19:46 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.64 #1 (Debian Bug?  What bug /\oo/\))
	id 1Jo5IS-0001gl-6E
	for linux-scsi@vger.kernel.org; Mon, 21 Apr 2008 19:19:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a general question and probably doesn't matter which kernel
(although the one in question is 2.6.23 vanilla)

I know that this device requires firmware to operate which has to be loaded
when the driver is loaded.

I'd like to have this driver compiled into the kernel.  My question is:

Can either of these be done:
1) Embed the firmware into the driver so that it can be used before the
rootfs id mounted.
2) Can the firmware be loaded in an initr{d,amfs}?  I personnaly despise
initr{d,amfs} and if this option is used, I'd prefer it not to be kernel
specific (as in having the driver for the card in the initr{d,amfs}) this
way a kernel upgrade wouldn't change the initr{d,amfs}.  I know there are
tools for this kind of thing, but I find it quite pointless to have the
driver in 2 places (in the init{r,amfs} and in /lib/modules)  I also realize
that "disks are cheap" blah blah, but that's not the point.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
