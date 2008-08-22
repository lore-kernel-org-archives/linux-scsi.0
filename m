From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Fri, 22 Aug 2008 15:48:46 -0700
Message-ID: <20080822224846.GH9169@plap4-2.local>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com> <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com> <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com> <48AF3547.4040703@emulex.com> <20080822220956.GC9169@plap4-2.local> <41b516cb0808221535n1d009bdaxb6ae6136b1f68c18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4978 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYHVWss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 18:48:48 -0400
Content-Disposition: inline
In-Reply-To: <41b516cb0808221535n1d009bdaxb6ae6136b1f68c18@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <chris.leech@gmail.com>
Cc: James Smart <James.Smart@emulex.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, 22 Aug 2008, Chris Leech wrote:

> > That's essentially what prompted this inquiry.  Sure, for hardware
> > CNA/HBA solutions, access to something like a raw-frame header seems
> > unnecessary.  What about software FCoE?  Would the openfcoe want this
> > export/expose these raw-frame data?
> 
> It's easy enough to provide software assists for lower level devices,
> so I'd say focus on what will work for HBAs and we'll make software
> FCoE work around that interface.  I don't see a reason to expose any
> extra level of detail here, if you want to see the full frame data in
> the software FCoE case you can always just capture the network
> traffic.

Fair enough...
