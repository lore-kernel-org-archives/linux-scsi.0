From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: iSCSI bug
Date: Thu, 05 Mar 2015 11:22:41 -0800
Message-ID: <1425583361.5860.12.camel@haakon3.risingtidesystems.com>
References: <D5289E78-CABB-4E26-A28B-7F0F04EFFEAD@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43314 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbbCETWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 14:22:44 -0500
In-Reply-To: <D5289E78-CABB-4E26-A28B-7F0F04EFFEAD@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edgaras =?UTF-8?Q?Luko=C5=A1evi=C4=8Dius?= <edgaras.lukosevicius@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Hi Edgaras,

Adding target-devel CC.

On Thu, 2015-03-05 at 17:56 +0200, Edgaras Luko=C5=A1evi=C4=8Dius wrote=
:
> Hello,
>=20
> we have a problem. iscsi connection is dropping constantly. After ena=
bling iscsi debug following message popped up after iscsi connection go=
t lost:
>=20
> # Kernel
> 3.18.6-1.el7.elrepo.x86_64
>=20
> Message from syslogd@storage-1 at Mar  5 15:55:12 ...
>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [iscsi_=
trx:11958]
>=20
> Message from syslogd@storage-1 at Mar  5 15:55:40 ...
>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_=
trx:11958]
>=20
> Message from syslogd@storage-1 at Mar  5 15:56:08 ...
>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_=
trx:11958]
>=20
> Message from syslogd@storage-1 at Mar  5 15:56:48 ...
>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_=
trx:11958]
>=20
>=20
> P.S.
>=20
> Kernel 3.19 acts same I just don=E2=80=99t have debug messages for it=
=2E --

Please send along the dmesg output of your system so we can have a look
at the specific soft lockup stack back-traces.

Thanks,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
