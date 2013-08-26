From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 19:45:38 -0400
Message-ID: <yq138pw3tjx.fsf@sermon.lab.mkp.net>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
	<yq1zjskgn1x.fsf@sermon.lab.mkp.net>
	<D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
	<yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
	<FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
	<yq1haeqcuce.fsf@sermon.lab.mkp.net>
	<088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3HZXps (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 19:45:48 -0400
In-Reply-To: <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
	(Sumit Saxena's message of "Mon, 19 Aug 2013 16:46:03 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ben Collins <ben.c@servergy.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maloy, Joe" <Joe.Maloy@lsi.com>

>>>>> "Sumit" == Saxena, Sumit <Sumit.Saxena@lsi.com> writes:

Sumit> LSI has megaraid_sas driver with big endian support for driver
Sumit> version "06.506.00.00". But to add big endian support for latest
Sumit> upstream megaraid_sas driver (06.600.18.00), we need to make some
Sumit> more changes. 

There are a few very important observations to make from that statement:

1. If you have big endian support patches already why aren't they
   upstream?

2. Why do you have diverging driver branches? An older version has big
   endian support but somehow that support is missing from a later
   version of the driver...

-- 
Martin K. Petersen	Oracle Linux Engineering
