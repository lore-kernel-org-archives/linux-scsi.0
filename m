From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/7] ibmvscsi code cleanup
Date: Fri, 12 Feb 2016 11:55:02 -0500
Message-ID: <yq1lh6p27ix.fsf@sermon.lab.mkp.net>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24240 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbcBLQzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2016 11:55:17 -0500
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
	(Tyrel Datwyler's message of "Wed, 10 Feb 2016 19:32:21 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com

>>>>> "Tyrel" == Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

Tyrel> Fixed up a couple spots that were out of line with the PAPR in
Tyrel> regards to its defined VSCSI protocol. Did away with some magic
Tyrel> numbers directly in the code. Fixed a minor endian issue.

Applied to 4.6/scsi-queue.

(And added the missing review from Johannes for patch 3 as pointed out
by James).

-- 
Martin K. Petersen	Oracle Linux Engineering
