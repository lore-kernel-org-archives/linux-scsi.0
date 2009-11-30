From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: OCZ Z-drive p84 read performance
Date: Mon, 30 Nov 2009 18:55:49 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C7556B@inbmail01.lsi.com>
References: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54251 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbZK3NZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2009 08:25:54 -0500
In-Reply-To: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryousei Takano <ryousei@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, "takano-ryousei@aist.go.jp" <takano-ryousei@aist.go.jp>, "Yang, Bo" <Bo.Yang@lsi.com>

Ryousei,

Replied inlined.

Thanks,
Kashyap


> -----Original Message-----
> From: Ryousei Takano [mailto:ryousei@gmail.com]
> Sent: Monday, November 30, 2009 3:08 PM
> To: Moore, Eric
> Cc: linux-scsi@vger.kernel.org; DL-MPT Fusion Linux; Support, Software;
> takano-ryousei@aist.go.jp
> Subject: OCZ Z-drive p84 read performance
> 
> Dear Eric Moore and all,
> 
> I am installing ubuntu 9.10 (kernel 2.6.31-14-server) on my PC, which
> has OCZ Z-Drive p84.
> This drive consists of LSI logic's SAS1068E controller and 4 MLC SSDs.
> I am using mptsas driver instead of the official binary driver
> (megasar). 
Is this megaraid driver or mpt fusion? 
Driver version?

 I ran simple read & write
> benchmark using dd(1). The result shows the throughput of sequential
> read achieves 260 MB/s,
> which is the half of sequential write performance (520 MB/s):
Setup information? 
> 
> block size  write (MB/s)  read (MB/s)
> 1024	201	241
> 4096	472	262
> 16384	486	267
> 65536	502	266
> 262144	472	259
> 524288	525	251
> 1048576	528	245
> 2097152	517	253
> 4194304	433	247
> 8388608	406	246
> 16777216	405	243
> 33554432	405	242
> 67108864	405	242
> 
> I wonder why read performance is worse than write performance.
> What is the bottleneck of read performance?
> 
> For more information, please see my page:
> http://code.google.com/p/pspacer/wiki/ZdrivePerformance
> 
> Any comments and suggestions will be welcome.
> 
> Best regards,
> Ryousei
