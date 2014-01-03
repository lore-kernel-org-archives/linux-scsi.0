From: jidanni@jidanni.org
Subject: Re: Bug#733565: SIX messages per on boot console should be TWO
Date: Sat, 04 Jan 2014 05:28:35 +0800
Message-ID: <87ha9kvjp8.fsf@jidanni.org>
References: <yq1ob3szun7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:50990 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaACV2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 16:28:48 -0500
Received: from homiemail-a4.g.dreamhost.com (caiajhbdcbef.dreamhost.com [208.97.132.145])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 9C4958966
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2014 13:28:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: ben@decadent.org.uk, 733565@bugs.debian.org, linux-scsi@vger.kernel.org

>>>>> "MKP" == Martin K Petersen <martin.petersen@oracle.com> writes:

MKP> We have to discover the basics of the disk before we can create the
MKP> gendisk/block device/request queue. And some of the subsequent
MKP> parameters we need can't be stored or acted upon until everything has
MKP> been set up. So some questions we have to ask several times.

Perhaps the messages could be each differentiated so the user doesn't see
them as something that looks like a bug and needs to be reported.

E.g., prefix/suffix with PHASE I CHECK, PHASE II CHECK, PHASE III CHECK.
or FIRST CHECK, INTERMEDIATE CHECK, FINAL CHECK,
or CHECK 1, CHECK 2...
or INTERMEDIATE PROBE:, FINAL PROBE:, etc.
