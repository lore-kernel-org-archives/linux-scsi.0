From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: /proc/scsi/aic7xxx/? considered harmful (2.4.19-pre9)
Date: Wed, 05 Jun 2002 20:54:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206060254.g562sa935892@aslan.scsiguy.com>
References: <15614.42400.697670.602385@notabene.cse.unsw.edu.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 06 Jun 2002 09:58:24 +1000."
             <15614.42400.697670.602385@notabene.cse.unsw.edu.au>
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>
>Hi,
> I have 3 NFS servers with ext3 on raid5 on scsi with assorted
>aic7xxx scsi controllers, all running 2.4.19-pre9 (plus some ext3 and
>raid and nfs patches) using the "new" aic7xxx drivers.

You need to use aic7xxx driver version 6.2.8 to avoid this problem.
Its been in Marcelo's tree for a bit, but I guess it missed pre9.

--
Justin
