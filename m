From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH C&C] gdth: remove GDTIOCTL_OSVERS
Date: Mon, 8 Aug 2005 14:33:56 +0400
Message-ID: <20050808103356.GA19957@mipter.zuzino.mipt.ru>
References: <20050807222829.GA20558@mipter.zuzino.mipt.ru> <20050808014027.GI4006@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.204]:20272 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750807AbVHHKZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 06:25:40 -0400
Received: by wproxy.gmail.com with SMTP id i2so198222wra
        for <linux-scsi@vger.kernel.org>; Mon, 08 Aug 2005 03:25:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050808014027.GI4006@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>

On Mon, Aug 08, 2005 at 03:40:27AM +0200, Adrian Bunk wrote:
> On Mon, Aug 08, 2005 at 02:28:29AM +0400, Alexey Dobriyan wrote:
> > -      case GDTIOCTL_OSVERS:
> > -      { 
> > -        gdth_ioctl_osvers osv; 
> > -
> > -        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
> > -        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
> > -        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
> > -        if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
> > -                return -EFAULT;
> > -        break;
> > -      }

> Not that I'd like this, but you know that this is a userspace-visible 
> change?

I know. I also know about uname(2), /proc/sys/kernel/osrelease,
/proc/version, uname(1).

OK, I'll schedule it for removal and give a #warning. How much time
will be enough with everyone? For the record: IMO, it should be zero in
this particular case.

