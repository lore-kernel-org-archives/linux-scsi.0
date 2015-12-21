From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/15] be2iscsi: Fix to process 25G link speed info from
 FW
Date: Mon, 21 Dec 2015 08:13:00 +0100
Message-ID: <5677A67C.4010006@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-14-git-send-email-jitendra.bhivare@avagotech.com>
 <5673CCC0.7000004@suse.de>
 <CAOA9gs36+ozeo=ZtqHYMvznwMSG6wKnG_zLOp__=wnKMkKv0CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbbLUHND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2015 02:13:03 -0500
In-Reply-To: <CAOA9gs36+ozeo=ZtqHYMvznwMSG6wKnG_zLOp__=wnKMkKv0CA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/21/2015 04:00 AM, Jitendra Bhivare wrote:
> Yes, the faults are not being used, it just adds to the confusion,
> where we just want to get the link state change up or down.
>
So make it a separate patch explaining this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
