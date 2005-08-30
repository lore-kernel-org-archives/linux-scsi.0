From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] fix compiler warning in aic7770
Date: Tue, 30 Aug 2005 16:51:57 +0200
Message-ID: <20050830145157.GB3708@stusta.de>
References: <200508300115.47618.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932165AbVH3OwB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200508300115.47618.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 30, 2005 at 01:15:36AM +0200, Jesper Juhl wrote:

> Fix compiler warning in drivers/scsi/aic7xxx/aic7770.c : 
>    drivers/scsi/aic7xxx/aic7770.c:129: warning: unused variable `l'
>...

This patch is already in 2.6.13-rc6-mm2 (through the scsi-misc-2.6.git 
tree).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
