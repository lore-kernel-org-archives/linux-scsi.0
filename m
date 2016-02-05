From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD are disabled
Date: Thu, 04 Feb 2016 22:16:14 -0500
Message-ID: <yq1zivfg83l.fsf@sermon.lab.mkp.net>
References: <20160204042528.GA15599@redhat.com>
	<1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
	<1454603812.22112.246.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27356 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbcBEDQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 22:16:25 -0500
In-Reply-To: <1454603812.22112.246.camel@localhost.localdomain> (Ewan Milne's
	message of "Thu, 04 Feb 2016 11:36:52 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, jiangyiwen@huawei.com, snitzer@redhat.com

>>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:

Ewan> Maybe it's unnecessary, but I would put parenthesis around (ret ==
Ewan> ... -EIO); for clarity.

Sure.

Ewan> I would prefer that additional enum/constant values be added to
Ewan> the end of the series, here you are changing the ordinal value of
Ewan> BLKPREP_DEFER from 2 to 3.  Could you swap these?

I felt that KILL and INVALID were closely related. That's why I kept
them together. But it doesn't matter to me.

-- 
Martin K. Petersen	Oracle Linux Engineering
