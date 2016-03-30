From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: Unexport scsi_is_fc_vport()
Date: Tue, 29 Mar 2016 20:51:15 -0400
Message-ID: <yq17fgkss8s.fsf@sermon.lab.mkp.net>
References: <56F9A418.5040607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48164 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338AbcC3Ave (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 20:51:34 -0400
In-Reply-To: <56F9A418.5040607@sandisk.com> (Bart Van Assche's message of
	"Mon, 28 Mar 2016 14:37:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, James Smart <james.smart@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Running the command "git grep -nHw scsi_is_fc_vport" shows that
Bart> this function is only called from inside
Bart> scsi_transport_fc.c. Hence unexport this function.

Applied to 4.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
