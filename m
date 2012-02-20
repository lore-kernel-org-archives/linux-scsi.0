From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Mon, 20 Feb 2012 12:44:48 -0500
Message-ID: <yq139a55rhr.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
	<20120216210301.GA27404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35112 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2BTRpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 12:45:06 -0500
In-Reply-To: <20120216210301.GA27404@redhat.com> (Mike Snitzer's message of
	"Thu, 16 Feb 2012 16:03:01 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> But testing with iSCSI, I get a NULL pointer _every_ time in the
Mike> iSCSI scatter-gather code,

I finally managed to get a WRITE SAME-capable iSCSI target set up.

Can you beam me your test case?

-- 
Martin K. Petersen	Oracle Linux Engineering
