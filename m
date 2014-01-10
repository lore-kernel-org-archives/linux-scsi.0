From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because of write_same check
Date: Thu, 09 Jan 2014 20:43:42 -0500
Message-ID: <yq1zjn4sjap.fsf@sermon.lab.mkp.net>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29345 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaAJBop (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 20:44:45 -0500
In-Reply-To: <52CEEC97.8050108@cs.wisc.edu> (Mike Christie's message of "Thu,
	09 Jan 2014 12:38:15 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: vaughan <vaughan.cao@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi <open-iscsi@googlegroups.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

>> 2. report_opcode is optional in SPC-3, so it's possible that not all
>> iscsi target support it. But is it correct for microsoft iSCSI target
>> to reject the command rather than return it with normal SCSI
>> response?

Mike> The iscsi spec has the reason code "command not supported" so I
Mike> guess it is ok for the target to do this. I do not think I have
Mike> ever seen that reason code used in production level targets, so it
Mike> is probably not common.

It's kind of unfriendly to not send a check condition...


Mike> I think we should implement handling in the iscsi layer for it. I
Mike> can make a patch if you have not already.

It would be awfully nice to get it turned into an ILLEGAL
REQUEST/0x20/0x0.

-- 
Martin K. Petersen	Oracle Linux Engineering
