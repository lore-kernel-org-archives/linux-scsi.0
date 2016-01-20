From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi-debug regression with 4.5-rc?
Date: Wed, 20 Jan 2016 10:57:11 -0500
Message-ID: <yq1powwp7l4.fsf@sermon.lab.mkp.net>
References: <1453303051.22112.110.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbcATP5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 10:57:16 -0500
In-Reply-To: <1453303051.22112.110.camel@localhost.localdomain> (Ewan Milne's
	message of "Wed, 20 Jan 2016 10:17:31 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Alasdair G Kergon <agk@redhat.com>

>>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:

Ewan> So I have a report from our test people that the optimal_io_size
Ewan> sysfs value is now different by a factor of 512 from what it used
Ewan> to be...

Yes, just prepared a patch this morning. I messed up sectors vs. bytes.

-- 
Martin K. Petersen	Oracle Linux Engineering
