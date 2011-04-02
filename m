From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT] isci: update for 4/1
Date: Sat, 2 Apr 2011 08:16:44 -0400
Message-ID: <20110402121644.GC30913@infradead.org>
References: <1301194067.28442.22.camel@dwillia2-linux>
 <1301706950.1429.9.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1DBMQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 08:16:44 -0400
Content-Disposition: inline
In-Reply-To: <1301706950.1429.9.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, hch@infradead.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

On Fri, Apr 01, 2011 at 06:15:50PM -0700, Dan Williams wrote:
> isci.git has been updated with bug fixes around error handling and
> cleanups driven by the ongoing review, details below.  The patches that
> have not appeared on the mailing list are included inline.

BTW, what the plan for the STP packet command code?  It's ifdef out in
a rather ugly way and already starting to bitrot.  Unless you plan to
resurrect it real soon I think we're better off removing it entirely
for now.

