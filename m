From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: fix missing { }, nullify kbuff_arr[i] only when necessary
Date: Wed, 23 Mar 2016 16:44:27 -0400
Message-ID: <yq1vb4c2ac4.fsf@sermon.lab.mkp.net>
References: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27500 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbcCWUon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 16:44:43 -0400
In-Reply-To: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Sun, 20 Mar 2016 17:03:32 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, James Bottomley <jbottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin,

Colin> Fix missing { } on if statement, this change will nullify
Colin> kbuff_arr[i] only where necessary as the code intended.

Arnd beat you to it. We already have a patch for this.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
