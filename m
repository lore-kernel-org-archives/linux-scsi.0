From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 17 Jul 2014 11:27:12 -0400
Message-ID: <yq1r41kovjj.fsf@sermon.lab.mkp.net>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	<20140626150208.GA14887@infradead.org>
	<1403808734.6440.12.camel@dabdike>
	<20140627075553.GB21799@infradead.org>
	<CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
	<CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
	<20140701081510.GA14857@infradead.org>
	<CAPK7rjdVM-Anw-uFc6RGCrwZko885vBGgbB+LehmuKF4r6nu5A@mail.gmail.com>
	<20140703171807.GA20300@infradead.org>
	<1404945498.2184.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540AbaGQP1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2014 11:27:46 -0400
In-Reply-To: <1404945498.2184.10.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Wed, 09 Jul 2014 15:38:18 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> Below is James' patch with a trivial comment fix and a proper
>> changelog.  James, can I get your signoff for this one?  I'll throw
>> it into the core-for-3.16 tree then.

James> OK, here it is.  I tweaked the comment to be accurate.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
