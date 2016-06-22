From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] lpfc: support for CPU phys_id and core_id on PowerPC64
Date: Tue, 21 Jun 2016 22:16:33 -0400
Message-ID: <yq1fus62cji.fsf@sermon.lab.mkp.net>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
	<20160621142902.GA10597@infradead.org>
	<57697C71.3060109@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcFVCR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2016 22:17:28 -0400
In-Reply-To: <57697C71.3060109@linux.vnet.ibm.com> (Mauricio Faria de
	Oliveira's message of "Tue, 21 Jun 2016 14:42:09 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, james.smart@broadcom.com

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio,

Mauricio> This turns out to still be the case w/ some distros where
Mauricio> ppc64/le usually runs,

Distros are free to carry a patch such as yours. That puts the burden on
them and not on upstream which is going in a different direction as
outlined by Christoph.

Mauricio> on which it would be easier to adapt this relatively small
Mauricio> change than moving forward w/ blk-mq/scsi-mq, for example --
Mauricio> even if the latter is clearly a superior approach.

This is ultimately Broadcom's decision. It is their driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
