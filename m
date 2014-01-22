From: Vijaya Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH] bfa: set correct command return code
Date: Wed, 22 Jan 2014 01:56:53 -0700
Message-ID: <51BD2AE8016AE441B63F5661159C99024A5206EB90@BRM-EXCH-3.corp.brocade.com>
References: <1389691585-84227-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:60384 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaAVI5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jan 2014 03:57:14 -0500
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id s0M8nQVF012009
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 00:57:14 -0800
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1hhc0f8m7y-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 00:57:14 -0800
In-Reply-To: <1389691585-84227-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, January 14, 2014 2:56 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Vijaya Mohan Guvva; Hannes Reinecke
> Subject: [PATCH] bfa: set correct command return code
> 
> For various error conditions the bfa driver just returns 'DID_ERROR', which
> carries no information at all about the actual source of error.
> This patch updates the error handling to return a correct error code,
> depending on the type of error occurred.

Thanks Hannes, Changes looks good to me.
Acked-by: Vijaya Mohan Guvva <vmohan@brocade.com>
