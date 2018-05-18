From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sg: allocate with __GFP_ZERO in sg_build_indirect()
Date: Fri, 18 May 2018 10:31:26 -0400
Message-ID: <yq1y3ghghmp.fsf@oracle.com>
References: <20180518142318.200260-1-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180518142318.200260-1-glider@google.com> (Alexander
        Potapenko's message of "Fri, 18 May 2018 16:23:18 +0200")
Sender: stable-owner@vger.kernel.org
To: Alexander Potapenko <glider@google.com>
Cc: jthumshirn@suse.de, jejb@linux.vnet.ibm.com, dgilbert@interlog.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-scsi@vger.kernel.org, dvyukov@google.com, hare@suse.com, torvalds@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org


Alexander,

> This shall help avoid copying uninitialized memory to the userspace
> when calling ioctl(fd, SG_IO) with an empty command.

Applied to 4.17/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
