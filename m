From: =?utf-8?Q?=C3=96zkan_G=C3=B6ksu?= <ozkan.goksu@usishi.com>
Subject: mpt3sas_cm2 attempting host reset for a 1 faulted disk
Date: Wed, 22 Nov 2017 17:56:53 +0200
Message-ID: <C8931243-3202-4343-9481-0CE8BEBC3A1F@usishi.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37682 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdKVO4D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Nov 2017 09:56:03 -0500
Received: by mail-wm0-f47.google.com with SMTP id v186so10763252wma.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2017 06:56:02 -0800 (PST)
Received: from [192.168.10.7] ([195.142.102.158])
        by smtp.gmail.com with ESMTPSA id e124sm1614596wmg.34.2017.11.22.06.56.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 Nov 2017 06:56:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have 5 jbod and i reach each one 2 sas cable with 5 LSI 3008.

Last day my cluster imported zfs pool to controller 2.
I was have 1 faulted disk in this pool already "sdhr".
When the pool imported on controller2 few sec or minute later I lost 1 =
jbod because mpt3sas_cm2 reset LSI card + expanders. After few sec i was =
able to use the jbod again.

But why? I was only have 1 faulted disk!.
If mpt3 will reset at every import for a faulted disk "which i have 390 =
disk, i will have 1-2 faulted disk its normal" we have a big problem!=20

LSISAS3008: FWVersion(15.00.00.00), ChipRevision(0x02), =
BiosVersion(08.35.00.00

My Kernel=3D  Linux 4.13.11-1-ARCH #1 SMP PREEMPT Thu Nov 2 10:25:56 CET =
2017 x86_64 GNU/Linux

Kernel log=3D=20
https://gist.github.com/morphinz/26812c7025c5125b4fa60e300ec76bd0

BTW: I lost index 2 and "sdhr" in that jbod:=
