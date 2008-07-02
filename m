From: malahal@us.ibm.com
Subject: Re: blk request timeout handler against 2.6.26
Date: Wed, 2 Jul 2008 12:43:13 -0700
Message-ID: <20080702194313.GA7112@us.ibm.com>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk> <20080513032012.GC9511@us.ibm.com> <20080619171741.GB819@linux.vnet.ibm.com> <20080620083738.GX20851@kernel.dk> <20080624101610.GN20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45174 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984AbYGBTnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 15:43:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m62JhFY0027321
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2008 15:43:15 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m62JhE3R080818
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2008 15:43:15 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m62JhEar002140
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2008 15:43:14 -0400
Content-Disposition: inline
In-Reply-To: <20080624101610.GN20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Jens Axboe [jens.axboe@oracle.com] wrote:
> > It's still alive, I'll update the branch with the latest stuff. Perhaps
> > we can even make 2.6.27, it should be about ready-cooked now.
> 
> I've updated the branch, mostly directly based on the updates and
> patches from Malahal.

I did a pull late last week and I didn't see the following lock patch in
the 'timeout' branch.

http://article.gmane.org/gmane.linux.scsi/41726/raw

Thanks, Malahal.
