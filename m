From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 09 Dec 2004 09:12:45 -0500
Message-ID: <1102601563.2784.20.camel@laptop.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B7F5278@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:11173 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261359AbULIOOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 09:14:20 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B7F5278@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, "Mukker, Atul" <Atulm@lsil.com>, Andrew Morton <akpm@osdl.org>, brking@us.ibm.com, bunk@fs.tum.de, "Doelfel, Hardy" <hdoelfel@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matt Domsch <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

On Thu, 2004-12-09 at 08:27 -0500, Salyzyn, Mark wrote:
> Bryan Henderson writes:
> >>can only be good because the applications and
> >>driver could be compiled on different archs.
> >
> >I'm having a hard time imagining where the application and the kernel 
> >could reasonably have been compiled for different architectures.
> They're 
> >running on the same machine, aren't they?
> 
> We have management applications that run remote. But we still
> standardize on byte ordering as well.

the packed in a userspace visible struct is a mistake.
Packing for a hw struct is basically ok-ish, but please don't expose the hw struct to userspace,
instead give userspace a sane, type safe and 32/64 bit translation safe interface and convert internally.
Pretty please?



