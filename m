From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 11:40:03 -0500
Message-ID: <yq1lh7kp5lo.fsf@sermon.lab.mkp.net>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
	<1453306765.2341.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28876 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934625AbcATQkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 11:40:12 -0500
In-Reply-To: <1453306765.2341.11.camel@HansenPartnership.com> (James
	Bottomley's message of "Wed, 20 Jan 2016 08:19:25 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> We should mark the commit causing the problems, which went into
James> 4.4 if I remember correctly:

James> Fixes: ca369d51b3e1649be4a72addd6d6a168cfb3f537 Cc:
James> stable@vger.kernel.org # 4.4+ Reviewed-by: James E.J. Bottomley
James> <James.Bottomley@HansenPartnership.com>

I'll add the tags. The reason I didn't explicitly put 4.4+ is that the
original commit has made its way quite far in various stable trees by
now.

-- 
Martin K. Petersen	Oracle Linux Engineering
