From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when
	device found
Date: Thu, 3 Jul 2014 19:11:06 +0200
Message-ID: <20140703171106.GA16788@lst.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41635 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaGCRLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2014 13:11:11 -0400
Content-Disposition: inline
In-Reply-To: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@parallels.com, elliott@hp.com, stephenmcameron@gmail.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

On Thu, Jul 03, 2014 at 10:05:57AM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Don't loop through all the devices even after
> finding the one we're looking for

The comments in the code seem to indicate that we want to modify
the queue depth for all LUNs on a given target.

Ccing Mike and Vasu as they wrote this code.

