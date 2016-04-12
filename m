From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector blacklist
Date: Mon, 11 Apr 2016 22:20:05 -0400
Message-ID: <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
	<570B63B8.6080104@tcnnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19875 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbcDLCUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 22:20:18 -0400
In-Reply-To: <570B63B8.6080104@tcnnet.com> (Michel Meyers's message of "Mon,
	11 Apr 2016 10:43:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michel Meyers <steltek@tcnnet.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>

>>>>> "Michel" == Michel Meyers <steltek@tcnnet.com> writes:

Michel> SYNOLOGY iSCSI devices do not work with large I/O and SYNOLOGY
Michel> changed the identifier of the devices

Shouldn't we just quirk SYNOLOGY, then?

-- 
Martin K. Petersen	Oracle Linux Engineering
