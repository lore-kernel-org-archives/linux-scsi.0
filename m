From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10-PI: Getting failed tag info
Date: Mon, 15 Dec 2014 19:30:41 -0500
Message-ID: <yq18ui8a11q.fsf@sermon.lab.mkp.net>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
	<1418426120.10743.73.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLPAar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 19:30:47 -0500
In-Reply-To: <1418426120.10743.73.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Fri, 12 Dec 2014 15:15:20 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

>>>>> "Nic" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

Nic> Also, AFAICT this patch still doesn't set the failed LBA, right..?
Nic> Any thoughts about the most sane way to get the failed LBA
Nic> information back to a caller like IBLOCK performing submission with
Nic> bio + bip..?

That's correct. My original patch did this.

More on that in my response to hch...

-- 
Martin K. Petersen	Oracle Linux Engineering
