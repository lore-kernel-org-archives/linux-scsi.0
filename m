From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Tue, 24 Jun 2014 19:11:47 -0400
Message-ID: <yq1simtgax8.fsf@sermon.lab.mkp.net>
References: <53A28B21.7070500@profihost.ag>
	<yq1ionwjn15.fsf@sermon.lab.mkp.net>
	<20140620155321.GA24389@soda.linbit>
	<yq1wqcbil0c.fsf@sermon.lab.mkp.net>
	<20140620182956.GB24389@soda.linbit>
	<yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
	<20140624115324.GB17123@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaFXXMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2014 19:12:22 -0400
In-Reply-To: <20140624115324.GB17123@soda.linbit> (Lars Ellenberg's message of
	"Tue, 24 Jun 2014 13:53:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>

>>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:

Lars> We are receiving (from network) and submitting (to lower level IO
Lars> stack) in the same context and would like the submit to be async.

Lars> Do you intend to provide an asynchronous interface?

I guess we can look into that if there is a need.

Do different clients share that context? I.e. does a synchronous discard
block other clients from accessing the drbd server?

-- 
Martin K. Petersen	Oracle Linux Engineering
