From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [OT] LDD3 Query
Date: Fri, 5 Apr 2013 16:53:07 -0700
Message-ID: <20130405235307.GA13235@kroah.com>
References: <CAJ61zBAP3E6bSaKSm=qwxnMyY_BBkA9W=kOMg-QSv90wJc=iTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49637 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163089Ab3DEXxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 19:53:09 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro12so1969404pbb.18
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 16:53:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAJ61zBAP3E6bSaKSm=qwxnMyY_BBkA9W=kOMg-QSv90wJc=iTw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vijay Chauhan <kernel.vijay@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 05, 2013 at 12:17:54PM +0530, Vijay Chauhan wrote:
> Hi,
>=20
> I am new to Linux Device Driver and reading LDD3.
>=20
> It mentions that the disadvantage of dynamic major number allocation
> is that you can=E2=80=99t create the device nodes in
> advance, because the major number assigned to your module will vary.

That's extremely out of date, all distros now use udev (or mdev) and as
such, dynamic major/minor are fine to use, and recommended.

> To solve this problem, it says that create a script to invoke insmod
> and after calling insmod, reads /proc/devices in order to create the
> special file(s).

Not needed anymore, udev handles this for you.

Hope this helps,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
