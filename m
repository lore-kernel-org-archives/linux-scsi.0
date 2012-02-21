From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Tue, 21 Feb 2012 16:31:53 -0500
Message-ID: <yq14nuj27qu.fsf@sermon.lab.mkp.net>
References: <20120216210301.GA27404@redhat.com>
	<yq139a55rhr.fsf@sermon.lab.mkp.net>
	<20120220184623.GA29931@redhat.com>
	<20120220234410.GC31853@redhat.com>
	<yq1k43h2gm9.fsf@sermon.lab.mkp.net> <20120221031854.GA468@redhat.com>
	<yq1pqd825zt.fsf@sermon.lab.mkp.net> <20120221065504.GB468@redhat.com>
	<yq1linw1i6e.fsf@sermon.lab.mkp.net>
	<20120221144145.GA4743@redhat.com> <20120221193312.GA6565@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35495 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2BUVcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2012 16:32:10 -0500
In-Reply-To: <20120221193312.GA6565@redhat.com> (Mike Snitzer's message of
	"Tue, 21 Feb 2012 14:33:12 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Yeah, it worked with the patch I provided in my previous mail too.
>> But ultimately the async stuff wasn't working for me due to merging.

New writesame3 branch on kernel.org. Please give it a whirl...

-- 
Martin K. Petersen	Oracle Linux Engineering
