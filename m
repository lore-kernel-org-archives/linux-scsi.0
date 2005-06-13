From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 13 Jun 2005 17:17:08 +0200
Message-ID: <20050613151708.GB12057@gmail.com>
References: <20050530150950.GA14351@gmail.com> <1117467248.4913.9.camel@mulgrave> <20050530160147.GD14351@gmail.com> <1117477040.4913.12.camel@mulgrave> <20050530190716.GA9239@gmail.com> <1118081857.5045.49.camel@mulgrave> <20050607085710.GB9230@gmail.com> <1118590709.4967.6.camel@mulgrave> <20050613145000.GA12057@gmail.com> <1118674783.5079.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:23821 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261627AbVFMPRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 11:17:20 -0400
Received: by wproxy.gmail.com with SMTP id 37so581196wra
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 08:17:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1118674783.5079.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, Jun 13, 2005 at 09:59:43AM -0500, James Bottomley wrote:

> Actually, the kernel appears to be wrong:

Oops, sorry, I took my grub conf and edited the bad entry :

title 2.6.12-rc6
#kernel (hd0,2)/bzImage-2.6.12-rc6 root=3D/dev/sdc2 parport=3Dauto vide=
o=3Dvesafb:mtrr,ywrap,1024x800-16@75 vga=3D0xF07
kernel (hd0,2)/bzImage-2.6.12-rc5 root=3D/dev/sdc2 parport=3Dauto video=
=3Dvesafb:mtrr,ywrap,1024x800-16@75 vga=3D0xF07 console=3DttyS0

to take the second option with the "console=3DttyS0" and forgot to upda=
te
it to (hd0,2)/bzImage-2.6.12-rc6.

Sorry for it, I can reboot my computer at 9pm (vdr is reccording till
9pm) and then I post the result :)

And don't worry, it's a vanilla 2.6.12-rc6 with only the scsi-misc and
the last patch, I even didn't patch for latest DVB.
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
