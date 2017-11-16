From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/3] zfcp: drop open coded assignments of
 timer_list.function
Date: Thu, 16 Nov 2017 15:45:51 +0100
Message-ID: <20171116154551.01934c5d@mschwideX1>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
        <20171108141709.79074-4-maier@linux.vnet.ibm.com>
        <cb2bd7ca-f240-285e-a804-90fa6f74b682@linux.vnet.ibm.com>
        <20171116131639.GA3462@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934048AbdKPOqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Nov 2017 09:46:00 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAGEjfUb015650
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 09:45:59 -0500
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2e9aj6qkwd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 09:45:59 -0500
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <schwidefsky@de.ibm.com>;
        Thu, 16 Nov 2017 14:45:57 -0000
In-Reply-To: <20171116131639.GA3462@osiris>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Remus <jremus@linux.vnet.ibm.com>

On Thu, 16 Nov 2017 14:16:39 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Thu, Nov 16, 2017 at 01:38:18PM +0100, Steffen Maier wrote:
> > If this has not been picked/merged yet (it's not in Linus' tree yet),
> > could you please drop it because it's buggy?
> > 
> > This would buy me time to come up with a proper solution,
> > otherwise I would be forced to fix it within 4.15-rc and
> > am not sure I can make it.  
> 
> It's not upstream and not in linux-next, so I guess it is in no tree.
> 
> So to make Kees' life easier the first two patches, including ("s390/scsi:
> Convert timers to use timer_setup()"), will simply go upstream via the s390
> tree together with the other conversion patches.

I have added the two zfcp related patches for the timer_setup conversion
to the s390/linux features branch.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
