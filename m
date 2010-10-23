From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Sat, 23 Oct 2010 11:17:46 -0600
Message-ID: <20101023171746.GH2447@parisc-linux.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45404 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0JWRRs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 13:17:48 -0400
Content-Disposition: inline
In-Reply-To: <20101023165924.GA1395@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Oct 23, 2010 at 06:59:24PM +0200, Christoph Hellwig wrote:
>  - setting of ordered tags in uas - dead code copied from old scsi
>    drivers.

Oops.  Meant to take that out.  Thanks.

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
