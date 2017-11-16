From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 3/3] zfcp: drop open coded assignments of
 timer_list.function
Date: Thu, 16 Nov 2017 14:16:39 +0100
Message-ID: <20171116131639.GA3462@osiris>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
 <20171108141709.79074-4-maier@linux.vnet.ibm.com>
 <cb2bd7ca-f240-285e-a804-90fa6f74b682@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934878AbdKPNRK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Nov 2017 08:17:10 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAGDGRMR103223
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 08:17:09 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e99qxd8gc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 08:17:05 -0500
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Thu, 16 Nov 2017 13:16:44 -0000
Content-Disposition: inline
In-Reply-To: <cb2bd7ca-f240-285e-a804-90fa6f74b682@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Remus <jremus@linux.vnet.ibm.com>

On Thu, Nov 16, 2017 at 01:38:18PM +0100, Steffen Maier wrote:
> If this has not been picked/merged yet (it's not in Linus' tree yet),
> could you please drop it because it's buggy?
> 
> This would buy me time to come up with a proper solution,
> otherwise I would be forced to fix it within 4.15-rc and
> am not sure I can make it.

It's not upstream and not in linux-next, so I guess it is in no tree.

So to make Kees' life easier the first two patches, including ("s390/scsi:
Convert timers to use timer_setup()"), will simply go upstream via the s390
tree together with the other conversion patches.
