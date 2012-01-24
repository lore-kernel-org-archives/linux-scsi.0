From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 15:04:02 -0500
Message-ID: <yq18vkw3m19.fsf@sermon.lab.mkp.net>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<yq162g13rsg.fsf@sermon.lab.mkp.net> <4F1F0B26.301@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:55567 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2AXUEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 15:04:12 -0500
In-Reply-To: <4F1F0B26.301@interlog.com> (Douglas Gilbert's message of "Tue,
	24 Jan 2012 14:48:54 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

>> I hadn't thought of that use case. Going to be a bit tricky given how
>> GET LBA STATUS works...

Doug> What's new in ACS-3 (t13.org ATA Command Set): .....
Doug>   f10138r6 Adds the ability for the device to return a
Doug>            list of the LBAs that are currently trimmed.

Doug> So it looks like t13.org are adding a GET LBA STATUS type
Doug> facility.  That in turn should lead to a SAT-3 (SCSI to ATA
Doug> Translation) definition of a mapping between both facilities.

Yep.

It is mostly how to handle the multi-range stuff going up the stack that
concerns me. We'd need something like FIEMAP...

-- 
Martin K. Petersen	Oracle Linux Engineering
