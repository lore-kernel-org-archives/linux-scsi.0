From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4] megaraid_sas: Fix LD/VF affiliation parsing
Date: Wed, 25 Jun 2014 22:08:46 -0400
Message-ID: <yq1lhskctht.fsf@sermon.lab.mkp.net>
References: <CAHtARFFK3yMX62JWRP-6wNm1T4Ff8E5wez-V=wyfpP6+44tNuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaFZCI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 22:08:57 -0400
In-Reply-To: <CAHtARFFK3yMX62JWRP-6wNm1T4Ff8E5wez-V=wyfpP6+44tNuA@mail.gmail.com>
	(adam radford's message of "Thu, 19 Jun 2014 17:32:00 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

>>>>> "adam" == adam radford <aradford@gmail.com> writes:

Adam,

Looks like all callers of megasas_get_ld_vf_affiliation() set initial to
0. So you can drop a bunch of code and that'll also take care of one
indentation level.

-- 
Martin K. Petersen	Oracle Linux Engineering
