From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 19:25:25 -0400
Message-ID: <yq17gf83uhm.fsf@sermon.lab.mkp.net>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
	<yq1zjskgn1x.fsf@sermon.lab.mkp.net>
	<D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
	<yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
	<FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
	<yq1haeqcuce.fsf@sermon.lab.mkp.net>
	<088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
	<3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
	<088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38575 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3HZXZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 19:25:35 -0400
In-Reply-To: <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
	(Sumit Saxena's message of "Mon, 26 Aug 2013 12:51:07 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Ben Collins <ben.c@servergy.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maloy, Joe" <Joe.Maloy@lsi.com>

>>>>> "Sumit" == Saxena, Sumit <Sumit.Saxena@lsi.com> writes:

>> I realize that the big-endian patch from Martin isn't complete for
>> fusion, but it is for other cards. 

Correct. I had no interest in Fury/Invader and no access to those
boards.


Sumit> Martin's patch does not have few changes needed in function
Sumit> "megasas_init_fw()"(inside file: megaraid_sas_base.c), 

Patches welcome!

-- 
Martin K. Petersen	Oracle Linux Engineering
