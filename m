From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
Date: Thu, 30 Mar 2017 11:30:57 -0400
Message-ID: <yq18tnm3hou.fsf@oracle.com>
References: <20170328044126.10006-1-famz@redhat.com>
        <yq1k2774hht.fsf@oracle.com> <20170330041311.GA32392@lemon.lan>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170330041311.GA32392@lemon.lan> (Fam Zheng's message of "Thu,
        30 Mar 2017 12:13:11 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Fam Zheng <famz@redhat.com> writes:

>> 	rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
>>                               BLK_DEF_MAX_SECTORS);
>
> Yes, it is better. Is it okay to make the change when you apply?

Sure. Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
