From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 4.8/scsi-queue sligthly outdated
Date: Tue, 21 Jun 2016 23:00:19 -0400
Message-ID: <yq1y45y0vy4.fsf@sermon.lab.mkp.net>
References: <5768FBC4.5030802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:40377 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcFVEXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 00:23:43 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5M31aB0008932
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 03:01:36 GMT
In-Reply-To: <5768FBC4.5030802@suse.de> (Hannes Reinecke's message of "Tue, 21
	Jun 2016 10:33:08 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes,

Hannes> your 4.8/scsi-queue branch sadly is missing the libata zac fixes
Hannes> which got pulled into upstream with commit
Hannes> e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697.

Yeah, I started 4.8 fairly early. Even before 4.7 final, I think.

I have rebased 4.8/scsi-queue on top of linus/master.

-- 
Martin K. Petersen	Oracle Linux Engineering
