From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Wed, 30 Mar 2011 03:23:48 -0400
Message-ID: <20110330072348.GA17919@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
 <20110327223256.GB7487@infradead.org>
 <1301448150.31206.15.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1C3HXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2011 03:23:51 -0400
Content-Disposition: inline
In-Reply-To: <1301448150.31206.15.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>

On Tue, Mar 29, 2011 at 06:22:30PM -0700, Dan Williams wrote:
> The expectation is that the lldd need not understand core internals
> outside of a set of interface functions.

I think you need to get rid of that stupid core/wrapper split ASAP,
as it's the root of a lot of the crap in this driver.  Removing all
the stupid indirections and duplicate structures it causes will
make the driver a lot smaller, and actually look like a normal Linux
driver and thus actually maintainable.
