From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [PATCH][BUGFIX] : megaraid patch for 2.10.1 (irq disable bug
	fix)
Date: Tue, 24 Feb 2004 09:47:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC3D9@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:1452 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262263AbUBXOrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 09:47:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> >> The following patch fixes a bug in megaraid driver version 2.10.1
> >> where irq was erroneously being disabled.
> >
> > Could we have a later version than 2.00.3 in 2.6 please?
We are in process of releasing a unified driver, which will natively support
the 2.4.x and 2.6.x kernels. 

Thanks
-Atul Mukker
