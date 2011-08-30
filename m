From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] lpfc: properly factor out debugfs code
Date: Tue, 30 Aug 2011 11:41:18 -0400
Message-ID: <a464b126-7dec-4f4c-95e5-5d2fd31bd2d9@exht1.ad.emulex.com>
References: <20110826093737.GA22411@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:1531 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755210Ab1H3Pls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2011 11:41:48 -0400
In-Reply-To: <20110826093737.GA22411@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Iannicelli, Alex" <Alex.Iannicelli@Emulex.Com>, James Bottomley <JBottomley@Parallels.com>, James Smart <James.Smart@emulex.com>

Yes, I'll look into it.   The reg_val warning was a lapse in the compil=
er,=20
which can't detect setting of fields as the macros accessed the element=
 by=20
address.  We did submit a patch to quiet the compiler.

-- james s



On 8/26/2011 5:37 AM, J=C3=B6rn Engel wrote:
> Hello James!
>
> I'm currently preparing a janitorial patch series and noticed that
> this one already collides with some of your changes.  Can I leave it
> to you to fix up the collision and send on?
>
> J=C3=B6rn
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
