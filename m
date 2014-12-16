From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10-PI: Getting failed tag info
Date: Mon, 15 Dec 2014 19:32:09 -0500
Message-ID: <yq14mswa0za.fsf@sermon.lab.mkp.net>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
	<548BB911.6090905@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47089 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaLPAcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 19:32:13 -0500
In-Reply-To: <548BB911.6090905@vlnb.net> (Vladislav Bolkhovitin's message of
	"Fri, 12 Dec 2014 19:57:05 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Vlad" == Vladislav Bolkhovitin <vst@vlnb.net> writes:

>> One thing that needs to be done is to make returning these new errors
>> to userland conditional on !BIP_BLOCK_INTEGRITY. I'll put that on my
>> list.

Vlad> Ever without it this patch is quite valuable.

Well, the concern here is that the new magic errors bubble up to
userland applications that only check for EIO/EINTR.

-- 
Martin K. Petersen	Oracle Linux Engineering
