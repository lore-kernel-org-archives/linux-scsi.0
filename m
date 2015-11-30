From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
Date: Mon, 30 Nov 2015 12:34:52 -0500
Message-ID: <yq1vb8jgzlv.fsf@sermon.lab.mkp.net>
References: <564F910E.9070306@sandisk.com> <564F9190.5090103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31321 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbbK3Rfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2015 12:35:31 -0500
In-Reply-To: <564F9190.5090103@sandisk.com> (Bart Van Assche's message of
	"Fri, 20 Nov 2015 13:33:04 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

Bart> Use scsi_host_{get,put}() instead of open-coding these functions.
Bart> Compile-tested only.

Do you want me to queue this as a general cleanup for 4.5 (independently
of the leak patch)?

-- 
Martin K. Petersen	Oracle Linux Engineering
