From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Wed, 15 Sep 2004 00:56:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915075606.GA104166@sgi.com>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com> <20040915031834.GA102988@sgi.com> <20040915074744.A17264@infradead.org> <20040915073757.GA102330@sgi.com> <20040915074032.GN2304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:50887 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S262071AbUIOH4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 03:56:30 -0400
Content-Disposition: inline
In-Reply-To: <20040915074032.GN2304@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, james.bottomley@steeleye.com

On Wed, Sep 15, 2004 at 09:40:32AM +0200, Jens Axboe wrote:
> 
> Well if we are going to be picky, you should not be using braces for
> this single-line case at all :-)

I always figured that if one part of the "if" statement had braces,
then the whole thing should.  On a quick scan, I can't see anything
in CodingStyle that mandates minimal brace usage.

Am I missing something, or is this an unwritten advisory?  :-)

thanks

jeremy
