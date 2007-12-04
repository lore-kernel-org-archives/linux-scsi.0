From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-rc3-git2 softlockup detected
Date: Tue, 04 Dec 2007 20:27:41 +0530
Message-ID: <47556AE5.8010708@linux.vnet.ibm.com>
References: <474D0AAC.5010005@linux.vnet.ibm.com> <20071127225328.9e3f3827.akpm@linux-foundation.org> <474D15FF.5080508@linux.vnet.ibm.com> <20071127232552.ad16e95c.akpm@linux-foundation.org> <474E5CAC.9000108@linux.vnet.ibm.com> <20071129003533.54b4b20e.akpm@linux-foundation.org> <20071130063929.GD2754@fattire.cabal.ca> <20071129230047.1b482562.akpm@linux-foundation.org> <20071129230204.8698f47e.akpm@linux-foundation.org> <474FBB86.5000004@linux.vnet.ibm.com> <20071204122005.GA27286@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:42773 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXLDO6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 09:58:12 -0500
In-Reply-To: <20071204122005.GA27286@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@debian.org>

Ingo Molnar wrote:
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>>> So 2.6.24-rc3 was OK and 2.6.24-rc3-git2 is not?
>> Yes, the 2.6.24-rc3 was Ok and this is seen from 2.6.24-rc3-git2/3/4.
> 
> just to make sure: this is a real lockup and failed bootup (or device 
> init), not just a message, right?
> 
> 	Ingo
> --

Hi Ingo,

This softlockup is seen in the 2.6.24-rc4 either and looks like a message because 
this is seen while running tbench and machine continues running other test's after 
the softlockup messages and some times seen with the bootup, but the machines reaches the 
login prompt and able to continue running tests.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
