From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: I have modified the megaraid driver v2.00.5 from kernel 2.6 t
	 o 2 .4.22-prex-ac1
Date: Fri, 25 Jul 2003 13:39:39 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307250440.NAA25924@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:6037 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S271113AbTGYEZR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 00:25:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: atulm@lsil.com, Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hi Matthew,

Haruo> Please explain in detail to a slight degree.
Haruo> Although it corresponds to PCI2001 by 2.6, 
Haruo> is it having stopped corresponding with my patch?

Matthew> No, not at all.  I'm criticising the original code here, not 
Matthew> your patch.In my opinion, we should simply delete these lines:

OK, I will leave an original code. 

Haruo> I think it priority to make it operate by 2.4.
Matthew> Is the driver in 2.4 not functional for you?
 
No, I should also operate the driver of v2.00.x by the kernel 2.4.

Matthew> In 2.5, it is finally possible to write a scsi driver that can cope
with
Matthew> the pci card being hotplugged.  The changes are actually not too
hard, but
Matthew> they do have some consequences we have to accept.
Matthew> For example, converting the sym8xx driver to this means the
controllers will
Matthew> be detected in a different order.  This is going to suck for some
people,
Matthew> but it's really unavoidable.  It doesn't look like megaraid would
have
Matthew> the same problem, though this comment scared me:
Matthew> but there's no code associated with it, so it doesn't matter.

Thank you for intelligible description. I understood in general.

Thanks!!
Haruo
