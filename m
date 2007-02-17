From: Dan Aloni <da-x@monatomic.org>
Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not
Date: Sat, 17 Feb 2007 18:04:25 +0200
Message-ID: <45D72789.7010801@monatomic.org>
References: <200702152306.25374.mgiammarco-ml@4warding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750923AbXBQQEy@vger.kernel.org>
In-Reply-To: <200702152306.25374.mgiammarco-ml@4warding.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mario Giammarco <mgiammarco-ml@4warding.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mario Giammarco wrote:
> Hello,
>
> I have two lsi logic 40919o 2gbit connected to a 2gbit switch.
>
> They see hard disks but when I try to use them as ip card I obtain a partial 
> failure: packets sometimes arrives sometimes no and on dmesg I see:
>
> mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
> 126)
> mptlan Mismatch between driver's buckets_out count and fw's
> BucketsRemaining count has crossed the threshold, issuing a LanReset
> to clear the fw's hashtable. You may want to check your
> /var/log/messages for "CRC error" event notifications.
> mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
>
>   
AFAIK these messages occur as a result of bad frame tx/rx, and it
doesn't get handled by the hardware/firmware very well, and I'm
quite sure it never did.

Now regarding the whole thing surrounding mptlan, I don't think
that LSI officially supports that feature any more or willing to fix
any bugs for it in their firmware or driver. Is that right?

If so, we might as well remove that driver from the kernel.

-- 
Dan Aloni
