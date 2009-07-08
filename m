From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mptspi: Unexpected doorbell active!
Date: Wed, 08 Jul 2009 14:16:14 -0400
Message-ID: <yq1vdm3f3bl.fsf@sermon.lab.mkp.net>
References: <4A54B611.2030802@interlog.com>
	<da824cf30907081106q336ba116r525a5470c496450c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:36367 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZGHSQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 14:16:29 -0400
In-Reply-To: <da824cf30907081106q336ba116r525a5470c496450c@mail.gmail.com>
	(Grant Grundler's message of "Wed, 8 Jul 2009 11:06:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

>>>>> "Grant" == Grant Grundler <grundler@google.com> writes:

>> Cute error message but it appears just before my machine locks
>> solid. It looks like it is coming from a LSI 53c1030 SPI controller
>> which lspci says is PCI-X but is actually PCIe.

Grant> It's probably not relevant to the problem, but I'm pretty sure
Grant> 53c1030 SPI is a PCI-X device. I supported this driver for HP's
Grant> IA64 (e.g rx2600) machines starting around 2001 or 2002 (before
Grant> PCIe was available).  Can you dump the lspci output that claims
Grant> this is a PCIe device?

I believe there is a 3rd party that makes PCIe 1030 boards.  They are
not directly marketed by LSI.

The boards consist of a PCIe to PCI-X bridge and a regular 1030 chip.

-- 
Martin K. Petersen	Oracle Linux Engineering

