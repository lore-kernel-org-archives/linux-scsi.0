From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector blacklist
Date: Tue, 12 Apr 2016 14:42:25 -0400
Message-ID: <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
	<570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
	<570CB1C8.5050106@tcnnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcDLSmk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 14:42:40 -0400
In-Reply-To: <570CB1C8.5050106@tcnnet.com> (Michel Meyers's message of "Tue,
	12 Apr 2016 10:28:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michel Meyers <steltek@tcnnet.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>

>>>>> "Michel" == Michel Meyers <steltek@tcnnet.com> writes:

>> Shouldn't we just quirk SYNOLOGY, then?

Michel> Could be worth it. As far as I can see, they manufacture no
Michel> directly attached drives (only NAS devices, which I presume are
Michel> all affected by the same problem as mine).

Mike: Any preference?

-- 
Martin K. Petersen	Oracle Linux Engineering
