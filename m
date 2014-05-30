From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] [SCSI] sd: Implement copy offload support
Date: Thu, 29 May 2014 20:05:34 -0400
Message-ID: <yq1y4xkb06p.fsf@sermon.lab.mkp.net>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	<1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
	<538748B2.2020508@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22830 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3AFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 20:05:47 -0400
In-Reply-To: <538748B2.2020508@interlog.com> (Douglas Gilbert's message of
	"Thu, 29 May 2014 10:48:18 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug,

Doug> SPC-4 has downgraded the RECEIVE COPY OPERATION PARAMETERS command
Doug> in favour of the new Third Party Copy (TPC) VPD page [0x8f]. If
Doug> the latter is present, it should be used. Most real world
Doug> implementations of XCOPY(LID1) comply (loosely) with SPC-2 and
Doug> SPC-3 since VMWare's VAAI is the effective "standard".

Indeed. None of my test targets supported the TPC VPD page (or only
parts of it) so that's stuck on my todo list for now. But my intent is
to check the VPD first and if it's not present (and 3PC is set) fall
back to RCOP.

I'd also like to add support for multiple segment descriptors. Another
item that's sparsely supported by the devices out there.

Doug> May I also point out the NAB's target subsystem has a block to
Doug> block XCOPY(LID1) implementation. So it can be used to test this
Doug> patch set. 

Yep. That's what I used for development.

-- 
Martin K. Petersen	Oracle Linux Engineering
