From: Dave Hansen <haveblue@us.ibm.com>
Subject: aic7xxx broken in 2.6.18-rc3-mm2
Date: Fri, 11 Aug 2006 15:11:48 -0700
Message-ID: <1155334308.7574.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:22734 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S964788AbWHKWMF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 18:12:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

My scsi card stopped being detected in 2.6.18-rc3-mm2, but works in
plain 2.6.18-rc3.  I bisected all the way down to the git-sas.patch.  I
then noticed that if I enable the AIC94XX driver, my card works again.

I'm digging through it right now, but I figured I'd post in case anyone
else had seen this.  This error mode seems vaguely familiar as well.
Any ideas?

-- Dave

