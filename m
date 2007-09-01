From: Andi Kleen <ak@suse.de>
Subject: Re: [Bug 8942] dac960 driver stopped working with 2.6.22 kernel series
Date: Sat, 1 Sep 2007 12:18:16 +0200
Message-ID: <200709011218.17129.ak@suse.de>
References: <bug-8942-27@http.bugzilla.kernel.org/> <20070831084259.fc2fd903.akpm@linux-foundation.org> <20070831161733.GC14130@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:56504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXIAKdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Sep 2007 06:33:18 -0400
In-Reply-To: <20070831161733.GC14130@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>, alex@nibbles.it, dac@conglom-o.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org


> So anyway, what's actually failing is one of these:

Thanks for the analysis.

In theory we could not fail DAC if the machine has <4GB RAM to work around
such buggy drivers, but then they would fail anyways with >4GB. Also
the failure was intended to allow some drivers to use more efficient non DAC
operation.

> It seems a bit mean to write off *all* VIA bridges as data-corruptors.
> Maybe the people who haven't had problems before can help us start a
> white-list of VIA PCI bridges that don't have a problem with DAC.

The reason I blacklisted all was that there was a small triple of data corruption
reports with VIA bridges. Also it's impossible to get any errata information
out of VIA. And there are not that many >4GB VIA systems because these
chipsets are usually used in lower end systems.

-Andi
