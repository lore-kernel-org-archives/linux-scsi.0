From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 6 Apr 2004 10:03:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F281@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48591 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263826AbUDFOEC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:04:02 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:=20
> On Mon, Apr 05, 2004 at 06:23:49PM -0400, Salyzyn, Mark wrote:
>> This would be unacceptable to our OEMs and users of our applications=
=2E
> Could you please stop this OEM crap?  No one cares more for someone j=
ust
> because he's an OEM. And we already had the stupid user discussion a =
few
> times, look up the long EVMS and Aun=FE Tilly threads.

And *that* is the root of the problem ... sigh ... but I will try not t=
ake the flame bait, for what now will no doubt be an infamous statement=
 of the goals of the Linux kernel community. I do not want to turn this=
 into a flame war, but rather have us admit our differences and respect=
 each other's needs.

OEMs and their users are virtually *all* we are concerned about. If we =
can not qualify our products within their needs, we disappear, or at le=
ast we disappear on operating systems that fail to provide for the need=
s of the users.

These users that are represented by us, and our OEMs, are overworked IS=
 people, working overtime hours, most likely working remote, and I am s=
orry, I *need* to tell them when they make a critical mistake, in the f=
og of their war, that will panic their system. I need to tell them, at =
the *instant* of the mistake, that they are about to delete an array th=
at is currently `in-use' by the operating system. I *really* need to te=
ll them that they are about to incorporate their in-use, possibly boot,=
 drive as a component of an array. I do *not* need to tell them that th=
ey are stupid.

I loose sleep at night thinking about these poor souls. No, to be hones=
t, actually it is because our OEM's test group thinks out fantastic sce=
narios of ways to break yours and my products and hold us accountable f=
or such failures. "Deleting array causes kernel ooops" news at 11 ...

Which reason do we ascribe to this failure of the operating system to p=
rovide the service of knowing if a drive is currently in-use:

1) system has been architected in such a manner that it would be imposs=
ible at this juncture to add?
2) Someone made a conscientious decision to not provide this functional=
ity?
3) There is a way to tell, it just is not clear to any of us at this mo=
ment?
4) There is a way to tell, but it would be an ugly hack that will no do=
ubt break upon the next revision (as this hack has done traversing from=
 2.4 to 2.6)?
5) Pride?
=20
Sincerely -- Mark Salyzyn

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
