From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 9 Dec 2004 08:27:15 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B7F5278@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:23956 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261222AbULIN11 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 08:27:27 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>, brking@us.ibm.com, bunk@fs.tum.de, "Doelfel, Hardy" <hdoelfel@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matt Domsch <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

Bryan Henderson writes:
>>can only be good because the applications and
>>driver could be compiled on different archs.
>
>I'm having a hard time imagining where the application and the kernel 
>could reasonably have been compiled for different architectures.
They're 
>running on the same machine, aren't they?

We have management applications that run remote. But we still
standardize on byte ordering as well.

Sincerely -- Mark Salyzyn
