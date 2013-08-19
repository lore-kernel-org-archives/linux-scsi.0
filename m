From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: State of big-endian for MegaRAID SAS driver
Date: Mon, 19 Aug 2013 16:46:03 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
	<yq1zjskgn1x.fsf@sermon.lab.mkp.net>
	<D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
	<yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
	<FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
 <yq1haeqcuce.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14179 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab3HSLQN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Aug 2013 07:16:13 -0400
In-Reply-To: <yq1haeqcuce.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Ben Collins <ben.c@servergy.com>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>

This patch: Big endian support for megaraid_sas driver is not complete. In few areas, we need to do changes like this patch does not have changes for Thunderbolt/invader/Fury controllers(file: megaraid_sas_fusion.c), and needs few changes in file: megaraid_sas_fp.c(while host reads some member of raidmap, it needs endianness change there also)..

LSI has megaraid_sas driver with big endian support for driver version "06.506.00.00". But to add big endian support for latest upstream megaraid_sas driver (06.600.18.00), we need to make some more changes.
We will get back with big endian support patch on top of latest upstream megaraid_sas driver.

Sumit

>-----Original Message-----
>From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>Sent: Friday, August 16, 2013 6:42 AM
>To: Ben Collins
>Cc: Martin K. Petersen; DL-MegaRAID Linux; linux-scsi;
>aradford@gmail.com
>Subject: Re: State of big-endian for MegaRAID SAS driver
>
>>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:
>
>Ben,
>
>Ben> Considering your patch has had two success stories (I suspect yours
>Ben> was on SPARC, so that would even make two different platforms) and
>Ben> low likelihood of regression on little endian, I think it's pretty
>Ben> safe.
>
>I ordered a MegaRAID card today so I can test on x86 just to be sure.
>
>
>Ben> The only thing I think that could make it better is to annotate the
>Ben> structures in megaraid_sas.h as __le32 where applicable.
>
>I have an older patch that does just that. And another one that gets rid
>of the 32-bit DMA limitations on large systems. But I didn't want to
>clutter the initial submission.
>
>--
>Martin K. Petersen	Oracle Linux Engineering


