From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 14:03:26 -0400
Message-ID: <AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
	<4C6C1D70.7020502@vlnb.net>
	<41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	<8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49638 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HWSD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 14:03:27 -0400
In-Reply-To: <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: landman@scalableinformatics.com, James Bottomley <James.Bottomley@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

I actually received 3+ off-post emails asking whether I was talking
about initiator or target in the 100K IOPS case below and what did I
mean by the ACKs.
I was referring to the 'Initiator' side.
ACKs =3D=3D When scsi-ML down-calls the LLD via the queue-command, proc=
ess
the sgl's(if you like) and then trigger the scsi_done up-call path.

Chetan Loke

On Mon, Aug 23, 2010 at 12:07 PM, Chetan Loke <chetanloke@gmail.com> wr=
ote:
> On Mon, Aug 23, 2010 at 11:11 AM, Bart Van Assche <bvanassche@acm.org=
> wrote:
>
>>
>> There is an important design difference between SCST and LIO: SCST b=
y
>> defaults creates multiple threads to process the I/O operations for =
a
>> storage target, while LIO only creates a single thread per storage t=
arget.
>> This makes SCST perform measurably faster.
>>
>
> Forget that. You could have discussed this if there were code reviews
> or other mainline inclusion emails from James B. From what I have
> heard, the decision was taken around 8-9 months back.
> Would anyone like to either comment/validate/refute this please? =C2=A0=
If
> not then I would kindly request these guys to stop taking us for a
> test drive. And also I'm not sure when was the last time James B.
> bench-marked our scsi-stack. Even if I ACK in the xmit-path then I
> can't push more than 100K IOPs. But other folks have re-engineered ou=
r
> linux-scsi stack and from what I've heard they can push > 300K+ IOPs.
> So I would just ignore performance discussion because I don't think
> folks have done even simple lame experiments in the last 1 year. Or
> may be I'm completely wrong and so please enlighten me so that I can
> re-run the tests.
>
>
>> Bart.
>>
> Chetan Loke
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
