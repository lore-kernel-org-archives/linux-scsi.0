From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi:Add missing error check in beiscsi_eeh_resume
Date: Mon, 29 Feb 2016 21:09:03 -0500
Message-ID: <yq1k2lnc5kw.fsf@sermon.lab.mkp.net>
References: <1456595005-13281-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcCACJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 21:09:17 -0500
In-Reply-To: <1456595005-13281-1-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Sat, 27 Feb 2016 12:43:25 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: jayamohan.kallickal@avagotech.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Nicholas" == Nicholas Krause <xerofoify@gmail.com> writes:

Nicholas> This adds the missing error check and path for if the call to
Nicholas> the function hwi_init_controller fails as this error path was
Nicholas> clearly missed when writing beiscsi_eeh_resume and thus we
Nicholas> must add it now in order to be able to handle this
Nicholas> nonrecoverable failing function call gracefully in
Nicholas> beiscsi_eeh_resume.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
