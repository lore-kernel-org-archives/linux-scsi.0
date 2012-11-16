From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Date: Thu, 15 Nov 2012 23:39:47 -0800
Message-ID: <F766E4F80769BD478052FB6533FA745D25EA94A704@SC-VEXCH4.marvell.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
  <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
 <1352203618.2529.22.camel@dabdike> <50997955.10000@gmail.com>
 <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
 <509D08B5.2080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509D08B5.2080303@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Xi

> > About patch 3, I check the ffz code and found it will check ~0 conditions.
> 
> Can you point me to the ~0 check in ffz code?  I also feel like using
> __ffs64 makes the code simpler.
Yes, it seem to be ok

> 
> Does patch 1 look good to you?  Thanks.
> 
Yes

Thanks!
