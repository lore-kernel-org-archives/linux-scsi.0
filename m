From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: UFS patchset
Date: Fri, 29 Apr 2016 20:24:24 -0400
Message-ID: <yq1eg9o6j0n.fsf@sermon.lab.mkp.net>
References: <57233664.3090101@synopsys.com>
	<yq1h9ekbo9j.fsf@sermon.lab.mkp.net> <572353C6.5070308@synopsys.com>
	<yq18tzw9cxg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbcD3AY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 20:24:29 -0400
In-Reply-To: <yq18tzw9cxg.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 29 Apr 2016 20:07:39 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Joao,

Martin> In a previous email you said you had sent v14 to
Martin> linux-scsi. However, I don't see neither v14, nor v13 in
Martin> patchworks. The latest I have is v12 and it does not apply to
Martin> 4.7/scsi-queue.

I found v14 in my mailbox. Not sure why it's not in patchworks.

In any case: It still doesn't apply to 4.7/scsi-queue and there are
several checkpatch warnings throughout the series. Please fix.

Also make sure to prefix your patch subject lines with "ufs:" so it's
easy to identify which subsystem they go into.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
