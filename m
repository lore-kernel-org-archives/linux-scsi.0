From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] SCSI: add 1024 max sectors black list flag
Date: Tue, 21 Apr 2015 04:01:30 -0700
Message-ID: <20150421110130.GA10424@infradead.org>
References: <1429587744-5666-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429587744-5666-1-git-send-email-michaelc@cs.wisc.edu>
Sender: stable-owner@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 20, 2015 at 10:42:24PM -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This works around a issue with qnap iscsi targets not handling large IOs
> very well.

:(

Looks like the best workaround, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
