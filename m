From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RESEND][PATCH 0/6] Fixes for memory corruption in mpt2sas
Date: Thu, 2 Jul 2015 13:15:05 -0700
Message-ID: <55959BC9.8000103@sandisk.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On 06/08/2015 08:50 PM, Calvin Owens wrote:
> This patchset attempts to address problems we've been having with
> panics due to memory corruption from the mpt2sas driver.
>
> I will provide a similar set of fixes for mpt3sas, since we see
> similar issues there as well. "Porting" this to mpt3sas will be
> trivial since the part of the driver I'm touching is nearly identical
> between the two, so I thought it would be simpler to review a patch
> against mpt2sas alone at first.
>
> I've tested this on a handful of large storage boxes over the past few
> weeks, so far it seems to have completely eliminated the memory
> corruption panics.

If you have to repost this series please convert 
BUG_ON(!spin_is_locked(&ioc->sas_device_lock)); into 
lockdep_is_held(...). Otherwise, for the whole series:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
