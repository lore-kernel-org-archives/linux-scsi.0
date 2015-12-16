From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/15] copy offload patches
Date: Tue, 15 Dec 2015 22:05:49 -0500
Message-ID: <yq1bn9rum7m.fsf@sermon.lab.mkp.net>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
	<yq1r3iuylwd.fsf@sermon.lab.mkp.net>
	<alpine.LRH.2.02.1512142018030.8189@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26457 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbbLPDGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 22:06:12 -0500
In-Reply-To: <alpine.LRH.2.02.1512142018030.8189@file01.intranet.prod.int.rdu2.redhat.com>
	(Mikulas Patocka's message of "Mon, 14 Dec 2015 20:22:42 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> Is there some software iSCSI implementation that supports
Mikulas> token-based copy? So that I could try to make support for it.

I did write support for token-based copy but it's in a different branch
from the xcopy stuff. I will have to reconcile those two branches and
then layer your stuff on top.

-- 
Martin K. Petersen	Oracle Linux Engineering
