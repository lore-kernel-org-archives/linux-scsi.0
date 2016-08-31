From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: sg: Use mult_frac, drop MULDIV macro
Date: Tue, 30 Aug 2016 22:19:54 -0400
Message-ID: <yq1poop7k8l.fsf@sermon.lab.mkp.net>
References: <20160819164357.26121-1-paul.burton@imgtec.com>
        <20160819164357.26121-2-paul.burton@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28664 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754970AbcHaCUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2016 22:20:05 -0400
In-Reply-To: <20160819164357.26121-2-paul.burton@imgtec.com> (Paul Burton's
        message of "Fri, 19 Aug 2016 17:43:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Burton <paul.burton@imgtec.com>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>

>>>>> "Paul" == Paul Burton <paul.burton@imgtec.com> writes:

Paul> The MULDIV macro is essentially a duplicate of the more standard
Paul> mult_frac macro. Replace use of MULDIV with mult_frac & drop the
Paul> duplication.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
