From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Thu, 15 Aug 2013 21:12:01 -0400
Message-ID: <yq1haeqcuce.fsf@sermon.lab.mkp.net>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
	<yq1zjskgn1x.fsf@sermon.lab.mkp.net>
	<D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
	<yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
	<FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3HPBMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Aug 2013 21:12:08 -0400
In-Reply-To: <FE68512D-F375-456B-948A-492634A02F0F@servergy.com> (Ben
	Collins's message of "Wed, 14 Aug 2013 22:52:58 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.c@servergy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aradford@gmail.com

>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:

Ben,

Ben> Considering your patch has had two success stories (I suspect yours
Ben> was on SPARC, so that would even make two different platforms) and
Ben> low likelihood of regression on little endian, I think it's pretty
Ben> safe.

I ordered a MegaRAID card today so I can test on x86 just to be sure.


Ben> The only thing I think that could make it better is to annotate the
Ben> structures in megaraid_sas.h as __le32 where applicable.

I have an older patch that does just that. And another one that gets rid
of the 32-bit DMA limitations on large systems. But I didn't want to
clutter the initial submission.

-- 
Martin K. Petersen	Oracle Linux Engineering
