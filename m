From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [ANNOUNCE] lsscsi 0.25 beta 1, adds --size
Date: Tue, 22 Mar 2011 00:43:54 -0400
Message-ID: <yq1bp13u5md.fsf@sermon.lab.mkp.net>
References: <4D7A870C.7040809@interlog.com> <4D878733.6020700@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:18306 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1CVEoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 00:44:03 -0400
In-Reply-To: <4D878733.6020700@interlog.com> (Douglas Gilbert's message of
	"Mon, 21 Mar 2011 18:13:23 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Recent versions of lsscsi will fail to show block devices with
Doug> recent kernels (e.g. lk 2.6.37 and lk 2.6.38) that have these
Doug> .config settings:
Doug>   CONFIG_SYSFS_DEPRECATED=y CONFIG_SYSFS_DEPRECATED_V2=y

Yeah. I don't really understand how the deprecated layout is supposed to
work. There's no way to get from a device to the corresponding block
node.

-- 
Martin K. Petersen	Oracle Linux Engineering
