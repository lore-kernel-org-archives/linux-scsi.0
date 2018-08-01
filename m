From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Wed, 1 Aug 2018 08:54:45 -0700
Message-ID: <20180801155445.GR1206094@devbig004.ftw2.facebook.com>
References: <20180730184052.13442-1-bart.vanassche@wdc.com>
 <20180730184052.13442-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180730184052.13442-3-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 30, 2018 at 11:40:52AM -0700, Bart Van Assche wrote:
> A long time ago the unfortunate decision was taken to add a self-
> deletion attribute to the sysfs SCSI device directory. That decision
> was unfortunate because self-deletion is really tricky. We can't drop
> that attribute because widely used user space software depends on it,
> namely the rescan-scsi-bus.sh script. Hence this patch that avoids
> that writing into that attribute triggers a deadlock. See also commit
> 7973cbd9fbd9 ("[PATCH] add sysfs attributes to scan and delete
> scsi_devices").

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
