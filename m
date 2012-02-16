From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Thu, 16 Feb 2012 14:12:25 -0500
Message-ID: <yq1ty2qa8yu.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
	<20120207214005.GG6346@redhat.com>
	<yq1hayugyv4.fsf@sermon.lab.mkp.net>
	<20120215153319.GA27312@redhat.com>
	<yq1fwebbgmq.fsf@sermon.lab.mkp.net>
	<20120216171640.GA11633@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40869 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2BPTMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 14:12:33 -0500
In-Reply-To: <20120216171640.GA11633@redhat.com> (Vivek Goyal's message of
	"Thu, 16 Feb 2012 12:16:40 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

>> 
>> I thought the same thing. But I was unable to trigger it.

Vivek> Given the fact that REQ_DISCARD will have REQ_TYPE_FS set, then
Vivek> second condition is anyway redundant and that explains why bug is
Vivek> not triggered.

You're right! Missed that first time around.

-- 
Martin K. Petersen	Oracle Linux Engineering
