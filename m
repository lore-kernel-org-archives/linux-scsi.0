From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Sun, 28 Jun 2009 23:21:36 -0400
Message-ID: <yq1zlbrn2rj.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:29685 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF2DV7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 23:21:59 -0400
In-Reply-To: <4A4472DF.1050900@turknet.net.tr> (Tarkan Erimer's message of
	"Fri, 26 Jun 2009 10:03:59 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> Hi, I just tried to plug a "Western Digital, My Book Series" USB
Tarkan> disk on 2.6.31-rc1. But, it failed to recognize it by saying
Tarkan> "READ CAPACITY failed". The same disk works fine with =<
Tarkan> 2.6.30.

Can you please mail us the output of...

# sg_inq /dev/sdb
# sg_readcap /dev/sdb
# sg_readcap -l /dev/sdb

... for that WD drive?

You may have to install the sg3_utils package.

-- 
Martin K. Petersen	Oracle Linux Engineering

