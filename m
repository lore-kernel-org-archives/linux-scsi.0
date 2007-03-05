From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Mon, 5 Mar 2007 13:00:56 +0000
Message-ID: <20070305130056.GA1312@infradead.org>
References: <1173032061.3372.67.camel@mulgrave.il.steeleye.com> <A67893E24596534CB03DD02157A7FBF7018D16C7@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37386 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbXCENBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2007 08:01:16 -0500
Content-Disposition: inline
In-Reply-To: <A67893E24596534CB03DD02157A7FBF7018D16C7@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Sun, Mar 04, 2007 at 12:06:36PM -0700, Dachepalli, Sudhir wrote:
> James,
> 
> How about the following:
> 
> 1. Cmd= Scsi_get_command( on physical device )  
> 2. Clone the scsi_cmnd fields of the virtual cmnd( command received by
> failover driver) to physical cmnd (the command allocated by

No.  Cloning fields of an existing scsi_cmnd will always get you into
trouble.

Can please stop this idiotic discussion now and can you and LSI Logic
please contribute on request based multipath instead of reinventing
it wrongly?

