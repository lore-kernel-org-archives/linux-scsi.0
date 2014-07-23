From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Tue, 22 Jul 2014 21:39:08 -0400
Message-ID: <yq14my8lupv.fsf@sermon.lab.mkp.net>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de>
	<1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
	<yq1bnsry69d.fsf@sermon.lab.mkp.net>
	<CAK=zhgoD9vVH0zCORTA2Mhu8Tf4m4VAih_hpig4PDdh-vgJmQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42275 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGWBjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 21:39:45 -0400
In-Reply-To: <CAK=zhgoD9vVH0zCORTA2Mhu8Tf4m4VAih_hpig4PDdh-vgJmQg@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 22 Jul 2014 12:03:48 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Hey Sreekanth,

Sreekanth> If we have single driver approach, making any changes in
Sreekanth> driver require lots of regression and Q/A cycle so that
Sreekanth> existing customer who are based on older controller does not
Sreekanth> have any impact due some fixes/new features.

Sreekanth> With all these HBA specific features, it is unmanageable to
Sreekanth> have a common driver for SAS2 and SAS3 HBAs.

But just as a counterexample to that: qla2xxx and lpfc are both capable
of driving a wide range of chip generations and firmware interface
versions with a single driver.

The problem I have with the mpt2sas/mpt3sas split is that there are way
more commonalities than there are differences. It is trivial to handle
multiple scatterlist format and features in a single driver. You guys
already do that in megaraid_sas.

-- 
Martin K. Petersen	Oracle Linux Engineering
