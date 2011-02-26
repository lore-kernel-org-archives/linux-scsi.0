From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Thin provisioning trivial Update
Date: Sat, 26 Feb 2011 12:22:59 -0500
Message-ID: <yq1ei6ur9qk.fsf@sermon.lab.mkp.net>
References: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
	<4D693628.7090301@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54402 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1BZRYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2011 12:24:48 -0500
In-Reply-To: <4D693628.7090301@interlog.com> (Douglas Gilbert's message of
	"Sat, 26 Feb 2011 12:19:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: shyam.iyer.t@gmail.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Memo to Martin Petersen and myself: scsi_debug needs options and
Doug> variables renamed due to these changes by t10.

Yeah, I have some patches pending for the next merge window that update
all this, including support for WRITE SAME(10).

-- 
Martin K. Petersen	Oracle Linux Engineering
