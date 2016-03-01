From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 2 Mar 2016 03:57:16 +1030
Message-ID: <56D5D0F4.4060301@internode.on.net>
References: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
 <20160301065247.GA6670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160301065247.GA6670@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Christoph Hellwig wrote on 01/03/16 17:22:
> Hi Jiang.
>
> I'd love to see this patch in and abuse of the old PCI API gone.
>
> Did you resolve the problems Arthur saw with the previous iteratons
> of the patch?
>

I applied Jiang Liu's patch of 1st March 2016 to a clean kernel 
4.5.0-rc6 source, removed my workaround of removing and re-adding the 
eata module before mounting file-systems that are on disks attached to 
the DPT SCSI card using the eata driver, and was able to kexec from the 
new kernel successfully.

Arthur.
