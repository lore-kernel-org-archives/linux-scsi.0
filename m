From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 8 Dec 2004 15:49:10 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B7F50FF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54187 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261308AbULHUtO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2004 15:49:14 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, Bryan Henderson <hbryan@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@osdl.org>, "Mukker, Atul" <Atulm@lsil.com>, brking@us.ibm.com, bunk@fs.tum.de, "Doelfel, Hardy" <hdoelfel@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Matt Domsch <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

>On Wed, 2004-12-08 at 15:08 -0500, Bryan Henderson wrote:
>>>> I would also suggest __attribute__((packed)) since you're sharing
with
>>>That's a bad idea, it forces the compiler to pessimise accesses to
the
>>>struct on most hardware.
>> How?  We're assuming that it won't actually affect the layout of this

>> struct, so what does the compiler pessimize?
>it also makes the compiler assume the struct members aren't aligned to
>the natural alignment and thus it'll emit more expensive access paterns
>on architectures that care about such things.

Time to fix the compiler?

Years of writing in itty bitty living spaces resulting in application
specific coding patterns has convinced me of one fact; it is not worth
it.

We are talking about not using a feature of the compiler for kernel/user
space portability in a rarely used interface because of petty
optimization issues.

Sincerely -- Mark Salyzyn

