From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Use 'blist_flags_t' for scsi_devinfo flags
Date: Wed, 15 Nov 2017 19:07:50 -0500
Message-ID: <yq1a7znqe5l.fsf@oracle.com>
References: <1510744050-53682-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510744050-53682-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 15 Nov 2017 12:07:30 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Hi Hannes,

> As per recommendation from Linus we should be using a distinct
> type for blacklist flags.
> -#define BLIST_MAX_1024		((__force __u32 __bitwise)(1 << 30))
> +#define BLIST_MAX_1024		((__force blist_flags_t)(1 << 30))

You are missing:

/* Use UNMAP limit for WRITE SAME */
#define BLIST_UNMAP_LIMIT_WS		((__force blist_flags_t)(1 << 31))

I'll fix it up...

-- 
Martin K. Petersen	Oracle Linux Engineering
