From: "Sanders, Richard" <Richard.Sanders@stratus.com>
Subject: megaraid port to alpha
Date: Mon, 15 Dec 2003 13:51:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <CAC3BCBB443DEC439198F230B4BCC7E905A70F7B@exna6-ftsaa.mis.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.16]:26250 "EHLO
	mailhub2.stratus.com") by vger.kernel.org with ESMTP
	id S263851AbTLOSv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 13:51:57 -0500
Received: from EXNA4.stratus.com (exna4.stratus.com [134.111.200.134])
	by mailhub2.stratus.com (8.9.3/8.9.3) with ESMTP id NAA08302
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2003 13:43:54 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am working on bringing up a 493 series megaraid card on an Alpha 264DP.  I
have made some mostly minor changes to the driver to get things working but
I have a few questions to the holders of the NDA docs.

The signature word from A0h PCI space is showing up as 0xBBBB... is this
another special case value like the 471 series being 0xCCCC?

On Alpha, the option rom code does not execute as it does on x86... this
means that the i960 firmware has not been started on the adapter at the
point where the driver loads.  I think I have performed a correct adapter
reset and firmware init sequence but the status byte I keep getting back is
1Ch which I cannot decode.  Is this init sequence something that can be
exposed in a GPL driver?  If so I would love some more detailed instructions
on how to correctly do it than my vague recollections.

And if this whole thing is a fool's errand that info would be appreciated
also.

I am working with driver 1.18f and LSI firmware 1.70.


Thanks.
Richard Sanders


This project is my own personal work and is neither endorsed nor funded by
my employer.
