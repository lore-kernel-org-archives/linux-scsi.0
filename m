From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi_debug: fix prevent_allow+verify regressions
Date: Tue, 24 Nov 2015 15:25:26 -0500
Message-ID: <yq1k2p7kuvd.fsf@sermon.lab.mkp.net>
References: <5651F740.3010707@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38332 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbKXUZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 15:25:37 -0500
In-Reply-To: <5651F740.3010707@interlog.com> (Douglas Gilbert's message of
	"Sun, 22 Nov 2015 12:11:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jbottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, sweet_f_a@gmx.de, util-linux@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Ruediger Meier observed a regression with the PREVENT ALLOW MEDIUM
Doug> REMOVAL command in lk 3.19:
Doug> http://www.spinics.net/lists/util-linux-ng/msg11448.html

Applied to 4.4.

-- 
Martin K. Petersen	Oracle Linux Engineering
