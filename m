From: Mark Lehrer <mark@knm.org>
Subject: Dell PERC monitoring via /proc
Date: Wed, 3 Aug 2005 15:24:05 -0600
Message-ID: <20050803212405.GA18762@knm.org>
Reply-To: mark@knm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-225-013.slc1.dsl.speakeasy.net ([66.93.225.13]:49362
	"EHLO home.knm.org") by vger.kernel.org with ESMTP id S261405AbVHCVYH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2005 17:24:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello there. We have an assortment of Dells with RAID controllers -
one uses aac and the others use megaraid.

In the latest kernels, is there any way to check the RAID status in
Linux through the /proc filesystem?  Dell seems to have some utilities
for Red Hat 7 but I am using FC3 and 2.6.12.

After spending some time on Google, it looks like megaraid used to
have a /proc/megaraid entry, but I don't see that on my system. 
aacraid looks like it has never had anything too useful.

Would it be possible to hack something in?  I haven't had a kernel
project in a couple of years, it might be fun.

Thanks,
Mark

