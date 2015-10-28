From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/12] megaraid_sas : Expose TAPE drives unconditionally
Date: Tue, 27 Oct 2015 22:13:36 -0400
Message-ID: <yq1wpu791v3.fsf@sermon.lab.mkp.net>
References: <201510150816.t9F8GgOq029543@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201510150816.t9F8GgOq029543@palmhbs0.lsi.com> (sumit saxena's
	message of "Thu, 15 Oct 2015 13:39:24 +0530")
Sender: stable-owner@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com
List-Id: linux-scsi@vger.kernel.org


Sumit> Expose non-disk(TAPE drive, CD-ROM) unconditionally. This issue
Sumit> is reported in Redhat Bugzilla [Bug 1254762].

RH bugzilla is not public so I removed this blurb from the patch
description.

In the future, please drop the spaces after megaraid_sas in patch
header. I fixed those up for now.

-- 
Martin K. Petersen	Oracle Linux Engineering
