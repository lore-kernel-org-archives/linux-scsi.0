From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/39] megaraid_sas : set residual bytes count during IO compeltion
Date: Tue, 07 Feb 2017 17:19:07 -0500
Message-ID: <yq1inolprtw.fsf@oracle.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486375212-17329-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <yq1poiuubbz.fsf@oracle.com>
        <c0f612adc620c800ec8be8d478134cfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41345 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932313AbdBGWTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 17:19:25 -0500
In-Reply-To: <c0f612adc620c800ec8be8d478134cfc@mail.gmail.com> (Kashyap
        Desai's message of "Tue, 7 Feb 2017 16:37:48 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

Kashyap> Data length will be always guaranteed to be a multiple
Kashyap> of the logical block size until and unless we have some
Kashyap> firmware defect.  In past, We have seen some partial/complete
Kashyap> DMA data length return from firmware was not aligned with
Kashyap> logical block size. Eventually, root caused + fixed in
Kashyap> firmware.

Great. Thanks for confirming!

-- 
Martin K. Petersen	Oracle Linux Engineering
