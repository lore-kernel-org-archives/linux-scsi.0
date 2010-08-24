From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 12:32:05 +0200
Message-ID: <AANLkTi=vjApRS+hXA8xuNv7NkfLmgCKvQFcMBPWEUeoB@mail.gmail.com>
References: <4C69653E.6050808@vlnb.net>
	<1282077040.16098.47.camel@mulgrave.site>
	<4C6C1DC1.8090208@vlnb.net>
	<1282164188.10878.22.camel@mulgrave.site>
	<4C702030.2070306@vlnb.net>
	<1282423128.3015.35.camel@mulgrave.site>
	<AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	<1282582740.11194.17.camel@mulgrave.site>
	<4C72CEC5.4080204@vlnb.net>
	<1282595927.11194.78.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50613 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0HXKcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 06:32:07 -0400
In-Reply-To: <1282595927.11194.78.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Aug 23, 2010 at 10:38 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Mon, 2010-08-23 at 23:40 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley, on 08/23/2010 08:59 PM wrote:
>> > My basic conclusion was that there's no incredible discriminator b=
etween
>> > LIO and STGT (although there are reams written on which performs b=
etter
>> > in which circumsances, is useful for clustering, supports ALUA, et=
c.
>> > each with partisans for the features).
>>
>> Here is a comprehensive features comparison I prepared some time ago=
:
>> http://scst.sourceforge.net/comparison.html. It's a bit outdated at =
the
>> moment, but I'm going to make it completely up do date in the next f=
ew days.
>
> That's not really going to help ... I don't really want another 500 m=
ail
> thread of partisan yelling about which is better. =A0I'm happy to con=
cede
> that either could beat the other on a given set of well chosen tests =
=2E..
> but knowing that is completely useless to me. =A0I can also guess, gi=
ven
> the antipathy, that neither of you would agree on a definitive set of
> comparison tests.
>
> So it comes down to a community test instead: which works better with
> the community. =A0This is important to me because it's an indication =
of
> what might ensue once code goes upstream and thus moves outside the
> exclusive province of the project to become a community resource. STG=
T
> is a community too and so far what you seem to have told me is:
>
> =A0 =A0 =A0* STGT users should just migrate to scst_local
> =A0 =A0 =A0* STGT doesn't have enough users to bother with
> =A0 =A0 =A0* STGT has fundamental design flaws which makes its pass t=
hrough
> =A0 =A0 =A0 =A0architecture unusable and its ABI flawed.
>
> I'm sure STGT appreciates the frank assessments, but it doesn't seem =
to
> merit too many "plays well with others" points.

Although it may not be clear from this thread, we respect the STGT
software and the all work the STGT authors have done to make it a
successful, stable and high performance storage target. The iSCSI-SCST
target driver even contains some of the code that was originally
written by an STGT author (Tomo) for a different project (IET).

A lot has already been discussed in this thread. It is already clear
that integrating LIO instead of SCST would hurt many SCST users. What
is not yet clear is what the consequences would be for LIO users if
SCST would be integrated instead of LIO ? A few months SCST has gained
support for persistent reservations (clustering). The SCSI engine of
SCST is powerful, and the core - target driver interface of SCST is a
rich interface. If there are any user-developed LIO target drivers,
it's probably relatively easy to port these to SCST.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
