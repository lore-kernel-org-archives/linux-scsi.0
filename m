From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_MMC_WR
Date: 27 Oct 2003 13:40:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067287253.2868.1.camel@patehci2>
References: <1065832684.2877.37.camel@patehci2>
	 <20031011082144.GK10614@suse.de>  <1066057325.2253.1.camel@patehci2>
	 <1066690691.2814.21.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:38331 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263463AbTJ0TlR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 14:41:17 -0500
In-Reply-To: <1066690691.2814.21.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

My 2003-10-13 -test7 patch, with the q=raw suffix included to help ask
for hard tabs etc. intact, appears archived as:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106669072008705&q=raw

Just now I triple-checked at my desk.  To -test9, that same patch
applies without complaint, produces precisely the same diff, and works.

I think that patch teaches Linux that standard mmc writable profile
devices are writable, in the least disruptive way possible.  I'm
delighted to see that patch shrunk and shrunk again as we tutored me
here.

Pat LaVarre


