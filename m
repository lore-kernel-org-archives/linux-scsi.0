From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: EBDA Question
Date: Mon, 7 Feb 2005 15:54:25 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BBD69C8@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:36052 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261179AbVBGUy2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 15:54:28 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

EBDA is safe to use during lilo and grub as part of a BIOS. As long as
the EBDA is properly formed.

However, it is considered 'bad behavior' to allocate much more than 4k
of EBDA as we find others (not Linux) that depend on the 640K region of
memory run out of this precious resource. Beware of several add-in
BIOSii that each allocate EBDA; nest/size/relocate/offset properly.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Moore, Eric Dean
Sent: Monday, February 07, 2005 2:45 PM
To: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: EBDA Question

EBDA - Extended Bios Data Area

Does Linux and various boot loaders(lilo/grub/etc)
having any restrictions on where and how big 
memory allocated in EBDA is? Is this
handled for 2.4/2.6 Kernels?

Reason I ask is we are considering having
BIOS(for a SCSI HBA Controller) allocating
memory in EBDA for Firmware use. 
We are concerned whether Linux would be writing
over this region of memory during the handoff
of BIOS to scsi lower layer driver loading.

Eric Moore
LSI Logic
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
