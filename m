From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sat, 03 Mar 2007 18:04:10 -0600
Message-ID: <45EA0CFA.8090101@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF7018D15CC@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46218 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXCDAEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Mar 2007 19:04:25 -0500
In-Reply-To: <A67893E24596534CB03DD02157A7FBF7018D15CC@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Dachepalli, Sudhir wrote:
> Where is the depricated warning that you mentioned about ?
> I tried to look in scsi_lib.c and scsi_device.h
> 

I meant in the first versions of the patches there was a warning. Did
you also try the workarounds mentioned in the bugzilla, to allocate
memory like sg and st?
