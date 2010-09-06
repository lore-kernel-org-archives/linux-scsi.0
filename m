From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 6 Sep 2010 13:28:53 -0400
Message-ID: <AANLkTindeFbbcp4kkQ6R8K594h4r8RcjpYWDvmTWg0DM@mail.gmail.com>
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
	<4C73DA15.2010207@vlnb.net>
	<1282661876.2993.20.camel@mulgrave.site>
	<4C7421FB.2060007@vlnb.net>
	<1282685014.32007.51.camel@haakon2.linux-iscsi.org>
	<4C76CA57.3050405@vlnb.net>
	<1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	<4C79484B.3090607@vlnb.net>
	<1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	<4C7C18CE.5020103@vlnb.net>
	<1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	<4C7FFD1A.8090509@vlnb.net>
	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49083 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab0IFR24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 13:28:56 -0400
In-Reply-To: <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Sep 2, 2010 at 4:25 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> I really have no idea what you are talking about 'behind closed doors=
'..
>
> Have you not been watching the amount of TCM/LIO patches on the
> linux-scsi list for the last 18 months..?
>

Please don't make me go public. I'm trying to keep my mouth shut
purely out of NDA. Inspite of that I've mentioned it publicly in my
last emails that the decision was made ~9 months ago? Someone told me
'LIO will be merged eventually and NOT scst'. This ain't open-source
development as we know it.

Also there are exactly 'ZERO' users/developers yelling 'NOT' to
include scst. So please stop your PR about LIO. Since no target
subsystems were ever chosen, I would think that LIO's list should have
some meat, no?And by now, the whole community knows that you have near
to zero meaningful/technical conversations on LIO's mailing list.  So
I'm not sure when you talk about your git workflow and your patches,
what you are actually talking about.


>> >>> It is obvious to even an casual observer from watching the TCM/L=
IO patch
>> >>> series that have been flying across the linux-scsi wire the last=
 24
>> >>> months that the major features (including PR and ALUA, and new f=
abric
>> >>> module drivers) have been developed individual feature bit by fe=
ature
>> >>> bit using a distributed git workflow in a bisectable manner. =C2=
=A0Each
>> >>> series was produced in such a manner that each patch could be re=
viewed
>> >>> individually by those interested parties.

Nothing needs to bisected. Just go to scst's svn repo and see the
checkin-flow over there if you want to satisfy your thirst. There are
no rules defined whatsoever that says that the patches need to follow
git-workflow. Since you are not an official kernel subsystem
maintainer no need to send you patches to get a buy-in.
Patches will be sent to James B and the scsi/kernel mailing list.


> Again, I suggest you watch the Russian translation of that talk on
> youtube and really understand what he means, aside from the insults t=
o
> subversion users.
>

svn is more than capable for what it is supposed to do. So no need to
tutor us on the source-control.


> 1) a userspace library in intrepted languages and 2) create high leve=
l
> applications using said userspace libraries that allow compatiblity t=
o
> be contained in the lib below.
>

An average user doesn't implement storage blobs. So I don't want to
worry about what they would think.This is your useless LIO PR and not
a missing feature in scst.


> Uhhh, I don't think so. =C2=A0Aside from your obvious project workflo=
w
> issues, the fact that SCST completly lacks a proper user-space driven
> representation of parent / child relationships between kernel level d=
ata
> structures in a fabric independent manner, while still allow for fabr=
ic
> dependent groups and attributes is a most definately show-stopper for
> me.
>

Show stopper for you? Sorry but you seem to be self-proclaimed
judge/maintainer pushing/speaking your vendor's/customer's agenda.

Ever noticed how screwed up the fc representations were? Take NPIV for
instance. No one laid down rules at that time? And just because your
so called vendor's/customer's may now be used to your LIO-way of doing
things, doesn't mean the whole community should be forced to do that.


> --nab

Chetan Loke
<English ain't my first language. I don't need any translation because
I speak one language - It's, Linux! The language and choice of the GNU
generation>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
