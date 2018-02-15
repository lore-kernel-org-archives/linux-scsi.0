From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Thu, 15 Feb 2018 18:44:19 -0500
Message-ID: <yq1bmgplsx8.fsf@oracle.com>
References: <20151209102453.GE3173@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151209102453.GE3173@mwanda> (Dan Carpenter's message of "Wed,
        14 Feb 2018 15:02:31 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


> On 64 bit CPUs there is a memory corruption bug on probe().  It should
> be a u32 pointer instead of an unsigned long pointer or we write past
> the end of the setupdata[] array.

Ondrej, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
