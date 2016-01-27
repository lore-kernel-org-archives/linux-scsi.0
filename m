From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Tue, 26 Jan 2016 21:06:16 -0500
Message-ID: <yq1fuxjixnr.fsf@sermon.lab.mkp.net>
References: <20160120194028.23159.25263.stgit@brunhilda>
	<20160120194141.23159.5168.stgit@brunhilda>
	<56A29C61.2040901@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31725 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcA0CGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:06:54 -0500
In-Reply-To: <56A29C61.2040901@pmcs.com> (Don Brace's message of "Fri, 22 Jan
	2016 15:17:21 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <brace77070@gmail.com> writes:

Don> It was pointed out to me by Kevin Barnett that I should also add a
Don> prototype in scsi.h.

Yes, please.

-- 
Martin K. Petersen	Oracle Linux Engineering
