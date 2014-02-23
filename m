From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] isci, libsas fixes for 3.4-rc2
Date: Sun, 23 Feb 2014 14:12:49 -0600
Message-ID: <1393186369.9743.4.camel@dabdike>
References: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50615 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbaBWUNH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 15:13:07 -0500
In-Reply-To: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, artur.paszkiewicz@intel.com, dave.jiang@intel.com, lukasz.dorau@intel.com


On Thu, 2014-02-06 at 12:22 -0800, Dan Williams wrote:
> Hi James,
> 
> Here are some collected fixes.  All but patch 2 are tagged for -stable.
> 
> Patch 1 and 4 have been on the list since before the 3.14 merge window,
> patch 2 and 3 are new.
> 
> Please apply, thank you.
> 
> [PATCH 1/4] isci: fix reset timeout handling
> [PATCH 2/4] scsi, libsas: introduce scmd_dbg() to quiet false positive "timeout" messages
> [PATCH 3/4] isci: fix needless ata reset escalations
> [PATCH 4/4] isci: correct erroneous for_each_isci_host macro

2,3 aren't really bug fixes; they're more enhancements (they make the
behaviour better but nothing breaks without them), so I'll queue 1,4 for
fixes and 2-3 for misc.

James



