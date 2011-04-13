From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Wed, 13 Apr 2011 12:44:25 -0400
Message-ID: <20110413164425.GA4279@infradead.org>
References: <20110408235518.GD18265@aontest.lm.intel.com>
 <1302676349.30034.36.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1DMQo1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 12:44:27 -0400
Content-Disposition: inline
In-Reply-To: <1302676349.30034.36.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Nadolski, Edmund" <edmund.nadolski@intel.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Wojcik, Artur" <artur.wojcik@intel.com>

On Tue, Apr 12, 2011 at 11:32:29PM -0700, Dan Williams wrote:
> Thanks.  We can do this a bit simpler and just move ram initialization
> completely out of the start path, where it does not really belong.
> 
> I'll fold the fix below into the patch.

That looks much better than the initial version.  I'm still not sure
there actually is much of a point of doing a lot of work in the 
start state handler.  Is there any fundamental reason for delaying work
from the normal init path?

