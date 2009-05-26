From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 4/4] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 26 May 2009 10:03:35 -0700
Message-ID: <da824cf30905261003j3edd0ab6jc0ac9299cc52b4cc@mail.gmail.com>
References: <1243113110-29635-1-git-send-email-mchan@broadcom.com>
	 <1243113110-29635-5-git-send-email-mchan@broadcom.com>
	 <da824cf30905260937s4029fe7crc723da03fba08c7b@mail.gmail.com>
	 <1243356541.29526.27.camel@HP1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:9030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbZEZRDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 13:03:37 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id n4QH3cOv014828
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 10:03:38 -0700
Received: from qyk42 (qyk42.prod.google.com [10.241.83.170])
	by zps76.corp.google.com with ESMTP id n4QH2fOs006999
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 10:03:37 -0700
Received: by qyk42 with SMTP id 42so5532719qyk.7
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 10:03:37 -0700 (PDT)
In-Reply-To: <1243356541.29526.27.camel@HP1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "davem@davemloft.net" <davem@davemloft.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On Tue, May 26, 2009 at 9:49 AM, Michael Chan <mchan@broadcom.com> wrot=
e:
=2E..
> Hi Grant, these are what we call "DMA control structures" as opposed =
to
> DMA packet data. =C2=A0Our chips are configured to do an additional 3=
2-bit
> endian swap on all DMA control structures. =C2=A0This way, all 32-bit=
 control
> fields (such as length, status, etc) will come out right when the dri=
ver
> reads these fields.
>
> If everything was defined as u32 in all these control structures, we
> wouldn't have to add the #ifdef. =C2=A0u8 and u16 fields have to be d=
efined
> this way or else big endian CPUs would read the wrong offset.
>
> If you look at some of the control structures in tg3.h, you'll see th=
e
> same thing.

Ah ok...so the chip is programmed configured to know about host endiane=
ss.
I'm familiar with tg3 having that and just hadn't noticed it here yet.

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
