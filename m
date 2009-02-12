From: Eyal Shani <Eyal.Shani@sandisk.com>
Subject: RE: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Thu, 12 Feb 2009 15:51:01 +0200
Message-ID: <22BDA4D9BA18634DB0CFBB2E5A1563446F98BAE155@KFAEXMIPV1.sdcorp.global.sandisk.com>
References: <20090123041558.GC24652@parisc-linux.org>
	 <4979AF62.7070409@redhat.com>
	 <1232721777.4430.7.camel@macbook.infradead.org>
	 <498DA052.6090605@redhat.com>
 <1234019372.4658.9.camel@localhost.localdomain> <498DB350.8000905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod8og116.obsmtp.com ([64.18.3.32]:49023 "EHLO
	exprod8og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBLOD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 09:03:29 -0500
In-Reply-To: <498DB350.8000905@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Eyal Shani <Eyal.Shani@sandisk.com>

Adding my 5 cents.

T13 added Trim to the latest ATA8 proposal.
http://www.t13.org/Documents/UploadedDocuments/docs2009/d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf

This is after the changes put into the definition, with 'Deterministic Read after Trim'.
This is not STANDARDIZED, but pretty much excepted by all sides.

I was hoping that would settle the differences between T10/T13 on this - little did I know...

We are working with David W. on his implementation for Trim feature, and hope to get to the bottom of debug process soon.
Hope to update soon...


Regards,
Eyal Shani.
