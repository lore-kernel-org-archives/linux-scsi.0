From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: fix upper bounds check of sense key in scsi_sense_key_string()
Date: Tue, 16 Aug 2016 00:51:47 -0400
Message-ID: <yq1ziodjoyk.fsf@sermon.lab.mkp.net>
References: <1471040407-5325-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36310 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcHPEwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2016 00:52:00 -0400
In-Reply-To: <1471040407-5325-1-git-send-email-tyreld@linux.vnet.ibm.com>
	(Tyrel Datwyler's message of "Fri, 12 Aug 2016 17:20:07 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

>>>>> "Tyrel" == Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

Tyrel> Commit 655ee63cf371 added a "Completed" sense string with key 0xF
Tyrel> to snstext[], but failed to updated the upper bounds check of the
Tyrel> sense key in scsi_sense_key_string().

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
