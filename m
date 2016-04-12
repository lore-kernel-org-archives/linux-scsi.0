From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector blacklist
Date: Tue, 12 Apr 2016 15:22:48 -0400
Message-ID: <yq137qqzl6f.fsf@sermon.lab.mkp.net>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
	<570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
	<570CB1C8.5050106@tcnnet.com> <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
	<570D4A19.40000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33347 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965754AbcDLTXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 15:23:00 -0400
In-Reply-To: <570D4A19.40000@redhat.com> (Mike Christie's message of "Tue, 12
	Apr 2016 14:18:49 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Michel Meyers <steltek@tcnnet.com>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:

>> Mike: Any preference?

Mike> I think quirking SYNOLOGY is best. It will be the safest route and
Mike> work for all devices.

Michel: Please spin a new version of the patch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
