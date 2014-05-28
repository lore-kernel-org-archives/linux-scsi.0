From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 3/4] scsi: increase upper limit for max_sectors
Date: Wed, 28 May 2014 16:18:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958ABC354@G4W3296.americas.hpqcorp.net>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
 <1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:11728 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaE1QTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 12:19:31 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id B5232E06
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 16:00:01 +0000 (UTC)
In-Reply-To: <1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Akinobu Mita
> Sent: Sunday, 25 May, 2014 7:44 AM
> To: linux-scsi@vger.kernel.org
> Cc: Akinobu Mita; Jens Axboe; James E.J. Bottomley; Douglas Gilbert
> Subject: [PATCH 3/4] scsi: increase upper limit for max_sectors
> 
...
> -	} else if (sdp->use_16_for_rw) {
> +	} else if ((this_count > 0xffff) || sdp->use_16_for_rw) {

Suggestion: reorder those so the unlikely case of a huge 
this_count is on the right side of the || operator.





