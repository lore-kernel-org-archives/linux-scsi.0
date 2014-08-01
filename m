From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Fri, 1 Aug 2014 05:20:42 -0700
Message-ID: <20140801122042.GA10771@infradead.org>
References: <20140708134003.GA7790@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140708134003.GA7790@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
branches.  I think we're in a good shape for the merge window, but
I'd still like to get reviewers attention for a few driver updates that
I'd love to get in still:

 - my eata patch to remove the driver_lock
 - the partially reviewed megaraid series
 - the arcmsr series
