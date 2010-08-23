From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 17:12:25 +0200
Message-ID: <AANLkTimttOUE5NiLc3cO5Eu3t70V9mnm+kSe25Ruh9ZB@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65443 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0HWPM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 11:12:28 -0400
In-Reply-To: <4C727BEB.9020100@scalableinformatics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: landman@scalableinformatics.com
Cc: James Bottomley <James.Bottomley@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Mon, Aug 23, 2010 at 3:47 PM, Joe Landman
<landman@scalableinformatics.com> wrote:
>
> James Bottomley wrote:
>
>> So the phrase "up to GigE" was deliberately in the above to exclude =
the
>> disputed infiniband results. =A0I'm not really interested in re-open=
ing
>> the arguments over how to interpret those results. =A0The fact that =
SCST
>> and STGT were on par up to 1GbE is enough to refute the contention t=
hat
>> STGT is "fundamentally slow".
>
> We haven't tested this in at least 6 months, but we did test iSCSI ov=
er 10GbE using SCST and STGT. =A0This was one of the reasons we wound u=
p going with SCST. =A0For the past several years, our performance on SC=
ST was much higher than on STGT.
>
> If it helps, we can redo these tests with a modern kernel (2.6.35.x) =
and same backend/frontend. =A0We've been switching most of our IO perfo=
rmance testing to Jens Axboe's excellent fio tool. =A0I'd be happy to s=
hare our testing decks with anyone (and collaborate on generating a goo=
d useful set for general use)
>
> This said, I have to add in my support to SCST and its developers. Vl=
ad, Bart, and the rest of the community have been very helpful to us. =A0=
We have been a consumer rather than a developer to date, so we have les=
s of a dog in this fight than others. =A0We have nothing against LIO or=
 STGT. =A0We will try them and see if they meet our needs. =A0SRP is a =
hard requirement, and it exists and works great in SCST. =A0So for us, =
a solution which gives us the best of all worlds would be one where we =
don't have to give up what works well for us, and gets us new capabilit=
ies/features. =A0This is more of a wish-list ... we have to keep using =
what works well for us.
>
> Our interest in STGT is that we would like a working iSER. =A0Vlad ha=
s suggested a method that we will explore a little later on (next
> month). =A0The LIO folks do look like they have some interesting capa=
bilities beyond this, so we will look. =A0But without SRP, and a fast i=
SCSI, their really isn't much choice for us in the near term.

(resending as plain text)

There is an important design difference between SCST and LIO: SCST by
defaults creates multiple threads to process the I/O operations for a
storage target, while LIO only creates a single thread per storage
target. This makes SCST perform measurably faster.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
