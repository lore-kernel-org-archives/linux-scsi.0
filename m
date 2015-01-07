From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Tue, 06 Jan 2015 19:17:32 -0500
Message-ID: <yq1tx0378bn.fsf@sermon.lab.mkp.net>
References: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1wq5zcjmd.fsf@sermon.lab.mkp.net>
	<CAK=zhgrr=9+3dynE6fuTikNwnBFKe5x=jA+UTzPKqfNAyXt_ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAGASJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:18:09 -0500
In-Reply-To: <CAK=zhgrr=9+3dynE6fuTikNwnBFKe5x=jA+UTzPKqfNAyXt_ow@mail.gmail.com>
	(Sreekanth Reddy's message of "Thu, 11 Dec 2014 17:44:03 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> I though to warn the user that the module parameter
Sreekanth> max_sgl_entries value what they provided is greater than the
Sreekanth> kernel defined SCSI_MAX_SG_SEGMENTS, whether if this module
Sreekanth> parameter value is greater than or less than the
Sreekanth> SCSI_MAX_SG_CHAIN_SEGMENTS. Also I thought, user may confuse
Sreekanth> if see observes SCSI_MAX_SG_CHAIN_SEGMENTS value instead of
Sreekanth> max_sgl_entries value in the warning message.

I would just prefer to see the value that is in effect. I know what I
provided as override value.

At the very least print a warning if you subsequently clamp the value to
MAX_SG_CHAIN_SEGMENTS. "Requested number of segments %u is bigger than
kernel max %u".

-- 
Martin K. Petersen	Oracle Linux Engineering
