From: malahal@us.ibm.com
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Wed, 5 Dec 2007 12:05:50 -0800
Message-ID: <20071205200549.GA29135@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com> <20071203024945.GO2584@parisc-linux.org> <20071203234703.GA16786@us.ibm.com> <20071204090053.GF23294@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52009 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXLEUG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 15:06:27 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB5K6CjJ007478
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 15:06:12 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB5K610W1405028
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 15:06:11 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB5K5qc5017229
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 13:05:52 -0700
Content-Disposition: inline
In-Reply-To: <20071204090053.GF23294@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com

Jens Axboe [jens.axboe@oracle.com] wrote:
> > This one fixes the 4-byte hole. Thank you very much.
> 
> That's all fine, but now we have two fields doing essentially the same
> thing. Care to cleanup the ->timeout usage so we can get by with using
> just that field?

I added another field because I couldn't find a way to use just one
field without breaking something! I will gladly clean it up if you
find a way to fix it.

Thanks, Malahal.
