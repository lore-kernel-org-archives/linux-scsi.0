From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Wed, 23 Mar 2011 04:40:54 -0400
Message-ID: <20110323084054.GA11533@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003455.27040.94947.stgit@localhost6.localdomain6>
 <20110318161852.GA19008@infradead.org>
 <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab1CWIk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 04:40:57 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 01:15:08AM -0700, Dan Williams wrote:
> > This just needs to go away. ?It's just a bad emulation of
> > Solaris/Windows style dynamically allocated timer lists, that just make
> > life harder for anyone trying to use it.
> 
> Yeah, started hacking at it [1], but it can all just be converted to
> delayed work.

Currently it's plain timers, converting it to a delayed work and thus
moving it to process context seems like a non-trivial conversions.

Does it buy you anything?

