From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Mon, 27 Jul 2009 11:55:58 -0400
Message-ID: <yq1bpn66rxt.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
	<yq1ocr66vy6.fsf@sermon.lab.mkp.net> <4A6DBEEB.5020302@panasas.com>
	<yq1fxci6tmc.fsf@sermon.lab.mkp.net> <4A6DCA7F.4080006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:50085 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZG0P4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 11:56:25 -0400
In-Reply-To: <4A6DCA7F.4080006@panasas.com> (Boaz Harrosh's message of "Mon,
	27 Jul 2009 18:40:47 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> if (sdev->scsi_level > SCSI_2)
Boaz> 	 sdev-> sdev_target->scsi_level = sdev-> scsi_level = SCSI_2;

Beautiful!

The suck of USB strikes back.

-- 
Martin K. Petersen	Oracle Linux Engineering
