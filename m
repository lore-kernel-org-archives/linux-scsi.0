From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: scsi_scan.c reports 'target allocation failed, error -6' w/
 mptsas
Date: Thu, 2 Feb 2012 13:45:45 +0100
Message-ID: <20120202124545.GG10289@dot.freshdot.net>
References: <20120118100635.GA19750@dot.freshdot.net>
 <A6888A6805518E4EA4AF7072A28264A6048BC1A714@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:44898 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2BBNQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2012 08:16:22 -0500
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6048BC1A714@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Quoting Nandigama, Nagalakshmi (Nagalakshmi.Nandigama@lsi.com):

> Sander, can you apply the attached patch and redo the test.

Thanks a bundle. I had to test this on a different machine but i could
reproduce the problem there too. This patch fixes the issues. The drive
can now be removed an replaced withouth the 'target allocation failed'
messages appearing.

Thanks a lot!

With regards,
-Sander.
-- 
| Man who scratches ass should not bite fingernail.
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
