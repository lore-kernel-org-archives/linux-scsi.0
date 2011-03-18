From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Fri, 18 Mar 2011 12:18:52 -0400
Message-ID: <20110318161852.GA19008@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003455.27040.94947.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab1CRQSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 12:18:55 -0400
Content-Disposition: inline
In-Reply-To: <20110207003455.27040.94947.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Sun, Feb 06, 2011 at 04:34:55PM -0800, Dan Williams wrote:
> 2/ Timer interface.

This just needs to go away.  It's just a bad emulation of
Solaris/Windows style dynamically allocated timer lists, that just make
life harder for anyone trying to use it.

Same for the whole events.c code, which is just pointless wrappers.

