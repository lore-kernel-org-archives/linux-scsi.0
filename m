From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: GET LBA STATUS response length correction
Date: Tue, 24 Jan 2012 13:47:21 -0500
Message-ID: <yq1ty3l2b0m.fsf@sermon.lab.mkp.net>
References: <4F18B588.3090106@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:55495 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2AXSr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 13:47:27 -0500
In-Reply-To: <4F18B588.3090106@interlog.com> (Douglas Gilbert's message of
	"Thu, 19 Jan 2012 19:30:00 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> The SCSI GET LBA STATUS command was introduced in SBC-3 revision
Doug> 20 in September 2009. At that time the Parameter Data Length field
Doug> in the response had an associated byte offset of 8.

Doug> Then in SBC-3 revision 25 (October 2010) that byte offset was
Doug> changed to 4. The sg_get_lba_status utility in sg3_utils version
Doug> 1.33 (released earlier today) has been changed to calculate
Doug> the newer response length. However the implementation of GET LBA
Doug> STATUS command in the scsi_debug driver still uses the original
Doug> byte offset.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
