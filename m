From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: megaraid: ABORTING problem
Date: Wed, 14 Apr 2004 09:43:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230C7D2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29110 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264214AbUDNNnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2004 09:43:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'Tomita, Haruo'" <haruo.tomita@toshiba.co.jp>, "Mukker, Atul" <Atulm@lsil.com>, 'Paul Wagland' <paul@kungfoocoder.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

>Please teach me how to build
>the latest unified driver(2.20.B1) by 2.6.5.

1. mkdir -p drivers/scsi/unified/beta
2. Extract the driver files into the directory
3. From that directory, run 
	make -C /usr/src/linux SUBDIRS=$PWD modules

>Is there any update patch from 2.00.3 to 2.20.B1?

2.20.B1 is a new effort. It doesn't have any incremental
patch from an older driver.

Sreenivas
