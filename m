From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 4.4 regression/bisected: error message due to "block/sd: Fix device-imposed transfer length limits"
Date: Fri, 15 Jan 2016 09:52:40 -0500
Message-ID: <yq1si1yuc7b.fsf@sermon.lab.mkp.net>
References: <56964DE0.60407@de.ibm.com> <yq1ziw9vck7.fsf@sermon.lab.mkp.net>
	<5696560D.2010105@de.ibm.com> <569906B5.3040103@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31701 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbcAOOwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2016 09:52:51 -0500
In-Reply-To: <569906B5.3040103@de.ibm.com> (Christian Borntraeger's message of
	"Fri, 15 Jan 2016 15:48:21 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Steffen Maier <maier@linux.vnet.ibm.com>

>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:

Christian> does the data make any sense to you?

I will try to reproduce with scsi_debug and your parameters. I'll get to
it later today.

-- 
Martin K. Petersen	Oracle Linux Engineering
