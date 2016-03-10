From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: fix dxferp in from_to case
Date: Wed, 09 Mar 2016 20:42:14 -0500
Message-ID: <yq1ziu7qfbd.fsf@sermon.lab.mkp.net>
References: <56D7CC31.3070800@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbcCJBmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 20:42:23 -0500
In-Reply-To: <56D7CC31.3070800@interlog.com> (Douglas Gilbert's message of
	"Thu, 3 Mar 2016 00:31:29 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, dvyukov@google.com

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Make sure that a user space pointer is passed through when data
Doug> follows the sg_header structure and command.  Fix the abnormal
Doug> case when a non-zero reply_len is also given.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
