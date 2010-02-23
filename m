From: Graham Reed <greed@pobox.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 23 Feb 2010 18:06:09 -0500
Message-ID: <5D98FCD1-62F9-4FA6-A9F4-72CB2305FA49@pobox.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se> <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org> <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com> <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49643 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0BWXGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 18:06:14 -0500
Received: from 76-10-128-202.dsl.teksavvy.com ([76.10.128.202] helo=kris.7deadly.org)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.68)
	(envelope-from <greed@pobox.com>)
	id 1Nk3pW-000AJi-4q
	for linux-scsi@vger.kernel.org; Tue, 23 Feb 2010 23:06:14 +0000
Received: from stefan.playnsync.com (CPE0021298e868f-CM0012c90d3a4e.cpe.net.cable.rogers.com [99.231.190.191])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by kris.7deadly.org (Postfix) with ESMTPSA id 3571A213D
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 18:06:09 -0500 (EST)
In-Reply-To: <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2010-Feb-23, at 5:11 AM, Caspar Smit wrote:
> I finally had some time to test your new patch.

I have as well.  And to sign up for this list.  My test setup was admittedly simple, an SFF PC with the SuperMicro AOC-SASLP-MV8 card and two laptop SATA drives from the parts drawer.

I set up two RAID 1 mirrors on the two hard disks; so each disk had two partitions.  This was to help locate issues with multiple operations on the same drive.

The mirrors initialized fine, and they ran fine with kernel builds running in each simultaneously.  While the mirrors were building, I tried hotplugging and hotunplugging a 3rd disk (on the other SFF connector) several times, and there was no interruption in the mirror progress.

I/O performance looked right in-line for the drives, which admittedly is down in the 45 MB/s range.

I'm also using Fedora 12, which means I took the latest kernel source, applied this patch, then built only mvsas as mv64xx.ko against the 2.6.31 line kernel in Fedora 12.  (I stole the name from the binary blob driver SuperMicro has on their "driver CD".)

So, a big "thank you" for the work so far.  This weekend, I will install the card in my main server at home (which is Fedora 11) and give it 8 1.5TB SATA disks in mirrored pairs to play with.

