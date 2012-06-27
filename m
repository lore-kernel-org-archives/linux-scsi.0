From: Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
Date: Wed, 27 Jun 2012 15:01:16 +0200
Message-ID: <20120627130116.GA3307@piware.de>
References: <1647133.Oeh9OMjxKH@donald.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1647133.Oeh9OMjxKH@donald.sf-tec.de>
 <4FCE30DE.6090903@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>, Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, David Zeuthen <zeuthen@gmail.com>, Kay Sievers <kay@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

Hello Randy, Eike,

Randy Dunlap [2012-06-05  9:16 -0700]:
> so why not make it a bool instead of an int value?

Rolf Eike Beer [2012-06-05 20:10 +0200]:
> This is wrong. Signed-off would mean that he takes the patch and passed it on. 
> So what this really is as you as the original author push this out is either 
> Acked-by, Tested-by, Reviewed-by or something like that.

I did not hear any other feedback, so I'm resending the patch with
these two changes.

Thanks,

Martin



-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
