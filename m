From: "Mukker, Atul" <atulm@lsil.com>
Subject: [ANNOUNCE] megaraid linux driver version 2.00.7
Date: Fri, 1 Aug 2003 16:39:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F3DA@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43716 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S272431AbTHAUju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2003 16:39:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "Jose, Manoj" <Manojj@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>

MegaRAID driver version 2.00.7 is released and can be download from

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.00.7/

Changes from 2.00.6:

i.	Adapter lock re-definition so that patch for kernels w/o per host
lock
	is less intrusive - Jens Axboe <axboe@suse.de>

ii.	While in abort and reset handling, check for non-empty pending list
is
	invalid. The intent is to wait for pending commands in FW to
complete,
	not the pending commands with the driver - Atul Mukker
<atulm@lsil.com>


Atul Mukker
Storage Systems
LSI Logic Corporation
U.S.A.
