From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: limit maximum cdb size to 252 bytes
Date: Wed, 25 Jun 2014 22:19:52 -0400
Message-ID: <yq1d2dwcszb.fsf@sermon.lab.mkp.net>
References: <53AB0166.8060905@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17036 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaFZCUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 22:20:01 -0400
In-Reply-To: <53AB0166.8060905@interlog.com> (Douglas Gilbert's message of
	"Wed, 25 Jun 2014 13:05:42 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Boaz Harrosh <bharrosh@panasas.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Boaz Harrosh commented on the "[PATCH v5] sg: relax 16 byte cdb
Doug> restriction" thread that SCSI variable length commands (which are
Doug> all SCSI commands greater than 16 bytes long) must themselves be a
Doug> multiple of 4 bytes long.

Doug> ChangeLog
Doug>   - limit the maximum cdb size permitted by the sg
Doug>     v3 interface to 252 bytes. Commands that large are called
Doug>     "variable length" and their length needs to be a multiple of
Doug>     4.

Doug> Original patch:
Doug>   Reviewed-by: Boaz Harrosh <boaz@electrozaur.com>

Doug> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
