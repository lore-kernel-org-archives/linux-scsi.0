From: christophe.varoqui@free.fr
Subject: Re: [sg3_utils] report target group
Date: Wed, 29 Dec 2004 09:03:17 +0100
Message-ID: <1104307397.41d264c5c5d3c@imp5-q.free.fr>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <41D21DDD.5010109@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:56273 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S261363AbUL2IDW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 03:03:22 -0500
In-Reply-To: <41D21DDD.5010109@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> I think the condition should be 'TPGS > 0' in a standard
> INQUIRY response (not necessarily the SCCS bit set).
>
Right, I didn't noticed the ALUA field got renamed to TPGS.

> Included in sg3_utils-1.12 beta which can be found at
> http://www.torque.net/sg [in the news section]. I made
> a few superficial changes. None of my hardware sets
> 'TPGS > 0' so I hope someone who has such hardware
> can test it.
>
I don't have the hardware either.

Line 206 & 214 in sg_rtg.c the payload offset might be 4 instead of 6, according
to the spec (page 216).

All changes acked.

Thanks,
cvaroqui
--
