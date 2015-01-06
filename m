From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM ATTEND] discuss blk-mq related to DM-multipath and status of XCOPY
Date: Tue, 06 Jan 2015 18:52:45 -0500
Message-ID: <yq1bnmb8o1e.fsf@sermon.lab.mkp.net>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39840 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbbAFXxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 18:53:18 -0500
In-Reply-To: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
	(Mike Snitzer's message of "Sun, 4 Jan 2015 12:16:57 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jej B <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Another topic we need to come to terms with is the state of XCOPY
Mike> (whether the initial approach needs further work, etc) -- Mikulas
Mike> Patocka reworked aspects of Martin's initial approach but it
Mike> hasn't progressed upstream:

Yeah, I'd like to get that sorted out too. It got stuck on running out
of request flags and that requires some block layer surgery. I'll try to
get that piece done right away for 3.20 so we can get xcopy into 3.21.

-- 
Martin K. Petersen	Oracle Linux Engineering
