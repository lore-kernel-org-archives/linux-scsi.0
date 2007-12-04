From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.24-rc3-git2 softlockup detected
Date: Tue, 4 Dec 2007 21:55:03 +0100
Message-ID: <20071204205503.GD32018@elte.hu>
References: <474D15FF.5080508@linux.vnet.ibm.com> <20071127232552.ad16e95c.akpm@linux-foundation.org> <474E5CAC.9000108@linux.vnet.ibm.com> <20071129003533.54b4b20e.akpm@linux-foundation.org> <20071130063929.GD2754@fattire.cabal.ca> <20071129230047.1b482562.akpm@linux-foundation.org> <20071129230204.8698f47e.akpm@linux-foundation.org> <474FBB86.5000004@linux.vnet.ibm.com> <20071204122005.GA27286@elte.hu> <47556AE5.8010708@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:40822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbXLDU4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 15:56:13 -0500
Content-Disposition: inline
In-Reply-To: <47556AE5.8010708@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@debian.org>


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> This softlockup is seen in the 2.6.24-rc4 either and looks like a 
> message because this is seen while running tbench and machine 
> continues running other test's after the softlockup messages and some 
> times seen with the bootup, but the machines reaches the login prompt 
> and able to continue running tests.

do you know whether there's any true delay when this happens, or is it a 
pure softlockup-detector false positive?

	Ingo
