From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi-debug regression with 4.5-rc?
Date: Sat, 05 Mar 2016 17:44:37 -0500
Message-ID: <yq1mvqc35pm.fsf@sermon.lab.mkp.net>
References: <1453303051.22112.110.camel@localhost.localdomain>
	<yq1powwp7l4.fsf@sermon.lab.mkp.net>
	<20160304152409.GA31358@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22792 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcCEWoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 17:44:44 -0500
In-Reply-To: <20160304152409.GA31358@redhat.com> (Mike Snitzer's message of
	"Fri, 4 Mar 2016 10:24:09 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Seems not, I think that BZ may be due to the LBPRZ clause in
Mike> commit 397737223 ("sd: Make discard granularity match logical
Mike> block size when LBPRZ=1") ?

Mike> should be: q->limits.discard_granularity = 1 * logical_block_size;

*blush*

Will fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
