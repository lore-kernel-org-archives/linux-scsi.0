From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC 0/2] scic: remove pointless stuctures
Date: Mon, 28 Mar 2011 09:20:46 -0400
Message-ID: <20110328132046.GA497@infradead.org>
References: <20110328000754.GA28347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1C1NUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 09:20:47 -0400
Content-Disposition: inline
In-Reply-To: <20110328000754.GA28347@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Start killing off the pointless sci_base* structures which do nothing
but causing a lot of unreadable code by converting forth and back
between them and the real structures.

I've done the sci_base_controller, and sci_base_request on a rainy
sunday afternoon, but the port, phy and remote device also need the
same treatment.  And after that the sci_base_object crap needs to
go in favour of just using container_of or properly typed pointers.

But I'll rather leave that to you Intel guys, spending more time
on this codebase won't be good for my mental health.
