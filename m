From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Thu, 27 Jul 2017 16:51:26 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5307D15C@avsrvexchmbx2.microsemi.net>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
        <yq1wp6uwp9c.fsf@oracle.com>
        <423FD6710FB8FB4F8728F93591889F9A5307D0DC@avsrvexchmbx2.microsemi.net>
 <yq1wp6tvo3x.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0081.outbound.protection.outlook.com ([104.47.40.81]:58264
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdG0Qvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jul 2017 12:51:43 -0400
In-Reply-To: <yq1wp6tvo3x.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

> Dave,
>=20
> > The issue is that we are making an inquiry response from
> > container/RAID info. We could also have included a "pad" byte to
> > terminate the string, as the fib data is 512 bytes. My assumption is
> > that somehow back in the day, someone managed to get odd characters
> > into the name.
> >
> > Terminating the string early would truncate the name ...
>=20
> So what do you propose as a fix?

We can add the pad byte to the struct, and terminate the string there. I'm =
out the office now, but Raghava or I will send up a patch ... That way, fol=
ks won't need to contemplate what appears to be a blatant out of bounds ref=
erence.

-Dave
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
