From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: new driver
Date: Wed, 18 Feb 2004 17:51:17 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7076215DFAA4574099E5CD59FE4222620427AC86@pcssrv42.pcs.pc.ome.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:54761 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S263898AbUBRIwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 03:52:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org, kschneider@bout-tyme.net, arjanv@redhat.com
Cc: "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>, "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>

Dear Eric,

Eric wrote;

Eric> There was an effort I started to open source some of
Eric> the driver, which was linked to a pre-compiled library. 

The pre-compiled library(megaide_lib.o) is included. 
The object of the megaide driver is created by linking this library.
I believe that the source of the exhibited portion is
a portion except the algorithm of RAID.
These are efforts and the results of Atul and Manoj.

However, since the library of binary distribution is included,
I think that the kernel version which operates will be limited.
If there is the solution method of this problem,
please let me know.

-- Haruo
