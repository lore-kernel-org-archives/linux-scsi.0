From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 10:55:40 -0400
Message-ID: <AANLkTincXYRiMnzvOBEDn=TKq42e1zC5EVjcmeMyq7gF@mail.gmail.com>
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
	<AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>
	<20100824072557.GK2804@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100824072557.GK2804@reaktio.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Bart Van Assche <bvanassche@acm.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2010 at 3:25 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.f=
i> wrote:
> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>> I actually received 3+ off-post emails asking whether I was talking
>> about initiator or target in the 100K IOPS case below and what did I
>> mean by the ACKs.
>> I was referring to the 'Initiator' side.
>> ACKs =3D=3D When scsi-ML down-calls the LLD via the queue-command, p=
rocess
>> the sgl's(if you like) and then trigger the scsi_done up-call path.
>>
>
> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599).

Uhm, that's MS(and it's closed tcp-chimney protocols and other
offloads?). And I think we discussed in bits and pieces about this on
scst already. Also, just because the driver is open sourced in linux
may not necessarily mean that we know all the ASIC registers that we
can bit-bang and squeeze every clock cycle out of the ASIC(just a
thought).

> How come there is such a huge difference? What are we lacking in Linu=
x?
I'm not a iscsi-guy. So I can't comment on how the data is moved from
n/w buffers to scsi-buffers etc etc.


>
> -- Pasi
Chetan Loke

>>
>> On Mon, Aug 23, 2010 at 12:07 PM, Chetan Loke <chetanloke@gmail.com>=
 wrote:
>> > On Mon, Aug 23, 2010 at 11:11 AM, Bart Van Assche <bvanassche@acm.=
org> wrote:
>> >
>> >>
>> >> There is an important design difference between SCST and LIO: SCS=
T by
>> >> defaults creates multiple threads to process the I/O operations f=
or a
>> >> storage target, while LIO only creates a single thread per storag=
e target.
>> >> This makes SCST perform measurably faster.
>> >>
>> >
>> > Forget that. You could have discussed this if there were code revi=
ews
>> > or other mainline inclusion emails from James B. From what I have
>> > heard, the decision was taken around 8-9 months back.
>> > Would anyone like to either comment/validate/refute this please? =C2=
=A0If
>> > not then I would kindly request these guys to stop taking us for a
>> > test drive. And also I'm not sure when was the last time James B.
>> > bench-marked our scsi-stack. Even if I ACK in the xmit-path then I
>> > can't push more than 100K IOPs. But other folks have re-engineered=
 our
>> > linux-scsi stack and from what I've heard they can push > 300K+ IO=
Ps.
>> > So I would just ignore performance discussion because I don't thin=
k
>> > folks have done even simple lame experiments in the last 1 year. O=
r
>> > may be I'm completely wrong and so please enlighten me so that I c=
an
>> > re-run the tests.
>> >
>> >
>> >> Bart.
>> >>
>> > Chetan Loke
>> >
>>
>> --------------------------------------------------------------------=
----------
>> Sell apps to millions through the Intel(R) Atom(Tm) Developer Progra=
m
>> Be part of this innovative community and reach millions of netbook u=
sers
>> worldwide. Take advantage of special opportunities to increase reven=
ue and
>> speed time-to-market. Join now, and jumpstart your future.
>> http://p.sf.net/sfu/intel-atom-d2d
>> _______________________________________________
>> Scst-devel mailing list
>> Scst-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/scst-devel
>
