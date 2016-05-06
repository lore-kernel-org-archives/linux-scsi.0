From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] megaraid: Downgrade two success messages to info
Date: Thu, 05 May 2016 21:05:07 -0400
Message-ID: <yq1wpn8vvwc.fsf@sermon.lab.mkp.net>
References: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48007 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbcEFBFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2016 21:05:19 -0400
In-Reply-To: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
	(Andy Lutomirski's message of "Tue, 3 May 2016 10:24:31 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

>>>>> "Andy" == Andy Lutomirski <luto@kernel.org> writes:

Andy> I actually read the error messages in my logs, and successful
Andy> initialization is not an error.

Andy> Arguably these log lines could be deleted entirely.

Applied to 4.7/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
