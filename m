From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/7] megaraid_sas : Jbod sequence number support
Date: Thu, 13 Aug 2015 13:08:50 -0400
Message-ID: <yq1si7nazfh.fsf@sermon.lab.mkp.net>
References: <201508071230.t77CTw3x021043@palmhbs0.lsi.com>
	<yq1h9o5e1li.fsf@sermon.lab.mkp.net>
	<84e4c58f0e2c8a184deb53e31edca6c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25812 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbHMRJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 13:09:27 -0400
In-Reply-To: <84e4c58f0e2c8a184deb53e31edca6c5@mail.gmail.com> (Sumit Saxena's
	message of "Wed, 12 Aug 2015 11:30:14 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@avagotech.com> writes:

Sumit> I will create separate patch for these new flags which are not
Sumit> related to JBOD sequence support. These flags are created to keep
Sumit> APIs in sync across driver and firmware.

*nod*

>> Why -1 here? Presumably MAX_PHYSICAL_DEVICES is a count, not an
>> index.
Sumit> Yes it is count only.  struct MR_PD_CFG_SEQ_NUM_SYNC has "struct
Sumit> MR_PD_CFG_SEQ" as one of its member so struct MR_PD_CFG_SEQ
Sumit> corresponding to PD index "0" is embedded inside struct
Sumit> MR_PD_CFG_SEQ_NUM_SYNC. That's why -1 here.

OK. Just checking.

-- 
Martin K. Petersen	Oracle Linux Engineering
