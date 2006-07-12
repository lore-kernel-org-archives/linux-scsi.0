From: "Suresh Kumar" <suresh_kumar@symantec.com>
Subject: ccsiss driver question
Date: Thu, 13 Jul 2006 02:43:11 +0530
Message-ID: <88E5AE973F06B840BABC730DD0DD7BFE171797@PUNAXCHEMBPIN02.enterprise.veritas.com>
References: <20051031200602.GA17753@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:63207 "EHLO
	extu-mxob-1.symantec.com") by vger.kernel.org with ESMTP
	id S932314AbWGLVNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2006 17:13:16 -0400
Received: from tus1opsmtapin02.ges.symantec.com (tus1opsmtapin02.ges.symantec.com [192.168.214.44])
	by extu-mxob-1.symantec.com (8.13.6/8.13.6) with ESMTP id k6CLDJ1v006665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2006 14:13:20 -0700
Received: from [10.137.18.178] (helo=SVL1XCHECNPIN01.enterprise.veritas.com)
	by tus1opsmtapin02.ges.symantec.com with esmtp (Exim 4.52)
	id 1G0m1D-0003Ab-GC
	for linux-scsi@vger.kernel.org; Wed, 12 Jul 2006 14:13:15 -0700
Content-class: urn:content-classes:message
In-Reply-To: <20051031200602.GA17753@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Does cciss driver support the ( deprecated) SCSI_IOCTL_SEND_COMMAND &&
SCSI_IOCTL_GET_IDLUN ioctls?
If not, is there a way to get these information from ccsiss driver
without resorting to the corresponding sg driver device?
Some code snippets which do this would be useful.

Also from userland, what would be an efficient way to get to the sg
driver equivalent given an sd or a cciss device path?
( ie. other than enumerating each sg device and matching
controller/target/lun values)

Thanks so much !!

suresh
