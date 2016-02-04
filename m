From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-mpath: fix a tiny case which can cause an infinite loop
Date: Thu, 04 Feb 2016 00:03:34 -0500
Message-ID: <yq1powdhxsp.fsf@sermon.lab.mkp.net>
References: <56B2B282.60400@huawei.com> <20160204032452.GA15344@redhat.com>
	<56B2CA48.9010802@huawei.com> <20160204042528.GA15599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45013 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcBDFEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 00:04:07 -0500
In-Reply-To: <20160204042528.GA15599@redhat.com> (Mike Snitzer's message of
	"Wed, 3 Feb 2016 23:25:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jiangyiwen <jiangyiwen@huawei.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, xuejiufei@huawei.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>, martin.petersen@oracle.com

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> The SCSI, or block layer, should return a non-retryable error for
Mike> this case.  But we only have the differentiated IO errors for SCSI
Mike> cmds that are issued, so it seems we still need to train SCSI (and
Mike> block by association/dependency) to return permanent errors that
Mike> are identified during request preparation.

There currently isn't any way to make BLKPREP_KILL return anything other
than -EIO. I'll take a look tomorrow...

-- 
Martin K. Petersen	Oracle Linux Engineering
