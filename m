From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] sysfs: Introduce sysfs_{un,}break_active_protection()
Date: Wed, 1 Aug 2018 08:53:54 -0700
Message-ID: <20180801155354.GQ1206094@devbig004.ftw2.facebook.com>
References: <20180730184052.13442-1-bart.vanassche@wdc.com>
 <20180730184052.13442-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180730184052.13442-2-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 30, 2018 at 11:40:51AM -0700, Bart Van Assche wrote:
> Introduce these two functions and export them such that the next patch
> can add calls to these functions from the SCSI core.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@vger.kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
