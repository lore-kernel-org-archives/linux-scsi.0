From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Add release function to sd for scsi_disk structure
Date: Wed, 22 Oct 2003 09:08:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022160855.GC1684@beaverton.ibm.com>
References: <20031018074040.GA1210@beaverton.ibm.com> <20031021092654.A22958@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:51076 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263686AbTJVQFV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 12:05:21 -0400
Content-Disposition: inline
In-Reply-To: <20031021092654.A22958@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> 
> This looks like a reasonable bandaid until the block layer is fixed.  
> 

Since I do not know the extent of the block layer changes maybe my
assumption is incorrect, but wouldn't will still need a release of some
kind to know when it is safe to do a free?

-andmike
--
Michael Anderson
andmike@us.ibm.com

