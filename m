From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Fix probing cards without io port
Date: Wed, 10 Aug 2016 22:29:49 -0400
Message-ID: <yq1d1lgrqaq.fsf@sermon.lab.mkp.net>
References: <20160806063734.31083-1-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbcHKCaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 22:30:00 -0400
In-Reply-To: <20160806063734.31083-1-yinghai@kernel.org> (Yinghai Lu's message
	of "Fri, 5 Aug 2016 23:37:34 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Yinghai" == Yinghai Lu <yinghai@kernel.org> writes:

Yinghai> Found one megaraid_sas HBA probe fails, [ 187.235190] scsi
Yinghai> host2: Avago SAS based MegaRAID driver [ 191.112365]
Yinghai> megaraid_sas 0000:89:00.0: BAR 0: can't reserve [io
Yinghai> 0x0000-0x00ff] [ 191.120548] megaraid_sas 0000:89:00.0: IO
Yinghai> memory region busy!

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
