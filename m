From: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>
Subject: Ultra 160 - what HA works well with 2.4 and 2.6?
Date: Tue, 4 Nov 2003 11:39:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031104103929.GA9585@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:37553 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S264059AbTKDKjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2003 05:39:32 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 8BECFFFB4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2003 11:39:31 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have marc'ed (as in googled or marc.theaimsgroup.com) this list a bit
to figure recommendations for SCSI host adaptors. Leaving Adaptec aside
(unaffordable), it appears as though qlogic 12160 and LSI 53C1010 based
adaptors were well supported and had maintained drivers, in 2.4 as in
2.6, with two drivers to choose from for qlogic.

The board is supposed to be used in software RAID1. (AMD XP1700+ w/ VIA
KT333).

Are there concerns that I should be aware of, for instance Dave Jones'
post-halloween-2003 doc (http://www.codemonkey.org.uk/post-halloween-2.5.txt)
mentions error handling, are there non-obvious concerns affecting the
qla1280 and sym53c8xx_2 drivers? Which works better? Anything else I
should consider?

Does it make a difference which brand the card will be? I have good
experience with the 53C875 based Tekram cards so far, but U160 is a
different League than UWSCSI.

Thanks in advance,

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
