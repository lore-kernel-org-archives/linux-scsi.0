From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Mon, 20 Feb 2012 19:07:58 -0500
Message-ID: <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
	<20120216210301.GA27404@redhat.com>
	<yq139a55rhr.fsf@sermon.lab.mkp.net>
	<20120220184623.GA29931@redhat.com>
	<20120220234410.GC31853@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22464 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2BUAIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 19:08:15 -0500
In-Reply-To: <20120220234410.GC31853@redhat.com> (Mike Snitzer's message of
	"Mon, 20 Feb 2012 18:44:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> The REQ_WRITE_SAME request, that SCSI is processing on behalf of
Mike> the dm_kcopyd_zero() generated bio, has multiple bios (as if
Mike> merging occurred).

Did you add a fix for the issue Vivek pointed out wrt. merging?

PS. I pushed an updated 'writesame2' branch to kernel.org.

-- 
Martin K. Petersen	Oracle Linux Engineering
