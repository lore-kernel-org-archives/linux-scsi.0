From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fcoe: Reduce max_sectors to 1024
Date: Wed, 9 Jul 2014 23:36:30 -0700
Message-ID: <20140710063630.GA13276@infradead.org>
References: <1404886581-3218-1-git-send-email-hare@suse.de>
 <20140709061838.GA28335@infradead.org>
 <53BCE3DE.6000605@suse.de>
 <1404932313.12914.36.camel@vfc0>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaGJGgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 02:36:35 -0400
Content-Disposition: inline
In-Reply-To: <1404932313.12914.36.camel@vfc0>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

Hannes, can you respin the patch with a comment explaining the limit?

> Does it limit IO size for pass through IO not through block layer ? 

The max_sectors limit also limits the size of passthrough requests.

