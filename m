From: Ryousei Takano <ryousei@gmail.com>
Subject: OCZ Z-drive p84 read performance
Date: Mon, 30 Nov 2009 18:37:48 +0900
Message-ID: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34739 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZK3Jhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 04:37:42 -0500
Received: by pzk1 with SMTP id 1so2388454pzk.33
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2009 01:37:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, support@lsi.com, takano-ryousei@aist.go.jp

Dear Eric Moore and all,

I am installing ubuntu 9.10 (kernel 2.6.31-14-server) on my PC, which
has OCZ Z-Drive p84.
This drive consists of LSI logic's SAS1068E controller and 4 MLC SSDs.
I am using mptsas driver instead of the official binary driver
(megasar).  I ran simple read & write
benchmark using dd(1). The result shows the throughput of sequential
read achieves 260 MB/s,
which is the half of sequential write performance (520 MB/s):

block size  write (MB/s)  read (MB/s)
1024	201	241
4096	472	262
16384	486	267
65536	502	266
262144	472	259
524288	525	251
1048576	528	245
2097152	517	253
4194304	433	247
8388608	406	246
16777216	405	243
33554432	405	242
67108864	405	242

I wonder why read performance is worse than write performance.
What is the bottleneck of read performance?

For more information, please see my page:
http://code.google.com/p/pspacer/wiki/ZdrivePerformance

Any comments and suggestions will be welcome.

Best regards,
Ryousei
