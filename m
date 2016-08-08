From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2] aacraid: Check size values after double-fetch from
 user
Date: Mon, 8 Aug 2016 10:24:25 +0200
Message-ID: <20160808082425.txbygo3tflrmwvw3@c203.arch.suse.de>
References: <20160805194410.7198-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805194410.7198-1-david.carroll@microsemi.com>
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, wpengfeinudt@gmail.com, scott.banesh@microsemi.com, Linux-SCSI <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 05, 2016 at 01:44:10PM -0600, Dave Carroll wrote:
>  In aacraid's ioctl_send_fib() we do two fetches from userspace, one 
>  the get the fib header's size and one for the fib itself. Later we use 
>  the size field from the second fetch to further process the fib. If 
>  for some reason the size from the second fetch is different than from 
>  the first fix, we may encounter an out-of- bounds access in 
>  aac_fib_send(). We also check the sender size to insure it is not
>  out of bounds. This was reported in
>  https://bugzilla.kernel.org/show_bug.cgi?id=116751 and was assigned
>  CVE- 2016-6480.
>  
> Reported-by: Pengfei Wang <wpengfeinudt@gmail.com>
> Fixes: 7c00ffa31 '[SCSI] 2.6 aacraid: Variable FIB size (updated patch)'
> Cc: stable@vger.kernel.org
> Signed-off-by: Dave Carroll <david.carroll@microsemi.com>

Thanks Dave,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
