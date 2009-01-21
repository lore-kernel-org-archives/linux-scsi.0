From: Henrik Stokseth <henrik@hw0.org>
Subject: Re: need help to merge (small) virtual scsi driver upstream.
Date: Wed, 21 Jan 2009 08:45:04 +0100
Message-ID: <4976D280.5000506@hw0.org>
References: <4974CED2.9000900@hw0.org> <20090121151113X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:6744 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZAUHpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 02:45:08 -0500
Received: by nf-out-0910.google.com with SMTP id d3so538466nfc.21
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2009 23:45:06 -0800 (PST)
In-Reply-To: <20090121151113X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linux SCSI ML <linux-scsi@vger.kernel.org>

=46UJITA Tomonori wrote:
>
>
> From a quick look at the patch, your driver links requests to a list
> and then the user-space daemon reads the requests via the special
> character device file and sends the response back to kernel space.
>
> If I correctly understand what you want, there are some possible
> alternatives, I guess.
>
> Note that I'm not sure 2) and 3) is acceptable to the SCSI maintainer=
=2E
>
>
> 1) use iSCSI initiator and target on the same machine
>
> First, set up iSCSI target software supporting CD/DVD. For example,
> you can use tgt (http://stgt.berlios.de), user-space program.
>
> Then you set up the iSCSI initiator to connect the target. Basically,
> the iSCSI initiator works like a virtual hba as you like. The iSCSI
> initiator and target communicate via tcp while your software
> communicates via the special character device.
>
> If you go with this setup, all you need are already in mainline.
>  =20

It would be desirable for us to rely upon an interface already present
in the mainstream kernel for practical reasons.

Pardon the dumb question but is it possible to talk to the TGT framewor=
k
without using iSCSI?
SCST has a nice user-space interface but I couldn't tell whether STGT
had something similar (as documentation is pretty much non-existent).

=E3=81=82=E3=82=8A=E3=81=8C=E3=81=A8=E3=81=86=E3=80=82


Sincerely,
Henrik Stokseth.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
