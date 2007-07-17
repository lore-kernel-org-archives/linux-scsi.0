From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 02:44:38 +0200
Message-ID: <469C10F6.3050008@googlemail.com>
References: <469BD9C8.4000808@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:59792 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbXGQApZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 20:45:25 -0400
Received: by ug-out-1314.google.com with SMTP id j3so45934ugf
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 17:45:24 -0700 (PDT)
In-Reply-To: <469BD9C8.4000808@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org

Gabriel C wrote:
> Hello,
>
> sdparm and hdparm are broken for me on git (
> abce891a10559343d8ac9f79b46d78afdba63a40 )
>
>
> ~$ sudo hdparm  /dev/sdc
>
> /dev/sdc:
>  BLKROGET failed: Inappropriate ioctl for device
>  BLKRAGET failed: Inappropriate ioctl for device
>  BLKGETSIZE failed: Inappropriate ioctl for device
>
>
> ~$ sudo sdparm  --all /dev/sdc
> unable to access /dev/sdc, ATA disk?
>
>   

Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

Maybe a bit off topic but it depends on EXPERIMENTAL so why the the menu
is not telling this ? and why the default is 'y' for it ?

IMO everything depends on EXPERIMENTAL should

1) Tell it is EXPERIMENTAL ( visible to the user in menu ) " Foo New
stuff ( EXPERIMENTAL ) "
2) Should not default to 'y' , is up to the users/admins to set
EXPERIMENTAL things to Y/M , isn't it ?


( PS: there are even defconfigs with EXPERIMENTAL things set to y but
this is really off topic )


Regards,

Gabriel C



