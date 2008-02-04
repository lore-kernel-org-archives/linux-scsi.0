From: 4news@retesintesi.it
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 21:06:10 +0100
Message-ID: <200802042106.11327.4news@retesintesi.it>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip-224-2.sn2.eutelia.it ([83.211.224.2]:60437 "EHLO
	mail.retesintesi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754583AbYBDULK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:11:10 -0500
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel@lists.sourceforge.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On luned=EC 4 febbraio 2008, Linus Torvalds wrote:
> So from a purely personal standpoint, I'd like to say that I'm not re=
ally
> interested in iSCSI (and I don't quite know why I've been cc'd on thi=
s
> whole discussion) and think that other approaches are potentially *mu=
ch*
> better. So for example, I personally suspect that ATA-over-ethernet i=
s way
> better than some crazy SCSI-over-TCP crap, but I'm biased for simple =
and
> low-level, and against those crazy SCSI people to begin with.

surely aoe is better than iscsi almost on performance because of the le=
sser=20
protocol stack:
iscsi ->  scsi - ip - eth
aoe -> ata - eth

but surely iscsi is more a standard than aoe and is more actively used =
by=20
real-world .

Other really useful feature are that:
- iscsi is capable to move to a ip based san scsi devices by routing th=
at (=20
i've some tape changer routed by scst to some system that don't have ot=
her=20
way to see a tape).
- because it work on the ip layer it can be routed between long distanc=
e , so=20
having needed bandwidth you can have a really remote block device spoki=
ng a=20
standard protocol between non ethereogenus systems.
- iscsi is now the cheapest san avaible.

bye,
marco.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
