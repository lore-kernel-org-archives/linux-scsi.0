From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI aic7xxx: kill kernel 2.2 #ifdef's
Date: Sun, 24 Oct 2004 11:46:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024094624.GB4216@stusta.de>
References: <20041023185609.GC3790@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:19730 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261412AbUJXJqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 05:46:55 -0400
Content-Disposition: inline
In-Reply-To: <20041023185609.GC3790@stro.at>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sat, Oct 23, 2004 at 08:56:09PM +0200, maximilian attems wrote:
> 
> previous was wrong also removed 2.4 compatibility sorry.
> resent
> 
> 
> the kjt patchset has an similar patch, that got sent to James:
> the bits below were a leftover of a janitor patch removing
> aic7xxx and aic79xx old ifdefs.
>...

Thanks for this information.

This patch seems pretty similar to my patch with the exception that it 
doesn't remove ahc_power_state_change.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

