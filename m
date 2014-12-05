From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it isn't provided
Date: Fri, 05 Dec 2014 08:22:03 -0500
Message-ID: <yq1mw72fczo.fsf@sermon.lab.mkp.net>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>
	<CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaLENWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 08:22:21 -0500
In-Reply-To: <CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
	(Ming Lei's message of "Fri, 5 Dec 2014 21:05:01 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>

>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:

>> There is absolutely no correlation between max write same blocks and
>> max unmap blocks. They are two entirely different commands. If QEMU
>> SCSI

Ming> Do you have any better idea for the problem?

Does QEMU SCSI set LBPRZ?

-- 
Martin K. Petersen	Oracle Linux Engineering
