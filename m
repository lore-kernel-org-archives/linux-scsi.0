From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05 of 16] Block layer data integrity
Date: Wed, 07 May 2008 16:22:21 -0400
Message-ID: <yq1tzh9zwxu.fsf@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
	<26ccaf2ccdc5548c4c9f.1209165127@sermon.lab.mkp.net>
	<20080506202909.GA25904@us.ibm.com>
	<yq1d4nyyizo.fsf@sermon.lab.mkp.net>
	<20080507025019.GA32000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:39051 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYEGUYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 16:24:00 -0400
Received: from agmgw2.us.oracle.com (agmgw2.us.oracle.com [152.68.180.213])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m47KNti2016498
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 14:23:55 -0600
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by agmgw2.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id m47BctC9012345
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 14:23:54 -0600
In-Reply-To: <20080507025019.GA32000@us.ibm.com> (malahal@us.ibm.com's message of "Tue\, 6 May 2008 19\:50\:20 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>>>> "Malahal" == malahal  <malahal@us.ibm.com> writes:

Malahal> Understandable for direct I/O. How does an application using
Malahal> mmap for writing can control this?

There's no way to control it :/


Malahal> Does that mean mmap writes are not really supported?

For now, yes.  Zach proposed unmapping the pages while I/O is in
progress.  I'll dig into that can of worms shortly...

-- 
Martin K. Petersen	Oracle Linux Engineering

