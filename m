From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is present
Date: Thu, 17 Jul 2014 11:43:48 -0400
Message-ID: <yq1mwc8ourv.fsf@sermon.lab.mkp.net>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	<1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
	<53C7B7F1.2060005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42078 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQPoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2014 11:44:00 -0400
In-Reply-To: <53C7B7F1.2060005@acm.org> (Bart Van Assche's message of "Thu, 17
	Jul 2014 13:48:01 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bvanassche@acm.org> writes:

Bart> Sorry for the late reply but it's only now that I noticed this
Bart> patch.  Are you sure that presence of a NAA descriptor is
Bart> mandatory ? This is what I found in SPC-4 r37 paragraph 7.8.6.2.1:

Bart> <quote> At least one designation descriptor should have the
Bart> DESIGNATOR TYPE field set to:
Bart> a) 2h (i.e., EUI-64-based);
Bart> b) 3h (i.e., NAA); or
Bart> c) 8h (i.e., SCSI name string).
Bart> </quote>

Bart> I think this means that presence of one of these three types of
Bart> descriptors is sufficient in order to be compliant with SPC-4.

That's correct and bad wording on my part. It's not mandatory in the SPC
sense. But the subset of the copy offload spec that vendors have
generally agreed on makes NAA a requirement.

You have a good point, however, and I'll tweak the code to make sure we
support 2h and 8h as well.

-- 
Martin K. Petersen	Oracle Linux Engineering
