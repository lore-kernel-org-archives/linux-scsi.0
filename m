From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] hpsa update
Date: Fri, 15 Jul 2016 15:41:10 -0400
Message-ID: <yq1zipihep5.fsf@sermon.lab.mkp.net>
References: <146739698564.24478.63853333596746262.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbcGOTlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:41:51 -0400
In-Reply-To: <146739698564.24478.63853333596746262.stgit@brunhilda> (Don
	Brace's message of "Fri, 1 Jul 2016 13:37:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> These patches are based on Linus's tree The changes are: - enhanced
Don> check for skipping masked devices - corrected hpsa_passthru_ioctl
Don> timeouts for fw flash

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
