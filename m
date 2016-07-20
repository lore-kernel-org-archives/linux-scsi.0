From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v9] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 20 Jul 2016 15:25:56 -0700
Message-ID: <1469053556.13881.18.camel@haakon3.risingtidesystems.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1467151535-1443-1-git-send-email-mikecyr@linux.vnet.ibm.com>
	 <1469045731.13881.4.camel@haakon3.risingtidesystems.com>
	 <826BCCF5-C1E3-4419-9EAB-D0A1253BAA29@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45478 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbcGTWZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 18:25:59 -0400
In-Reply-To: <826BCCF5-C1E3-4419-9EAB-D0A1253BAA29@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>, joe@perches.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

On Wed, 2016-07-20 at 15:26 -0500, Bryant G. Ly wrote:
> Hi Nic,=20
>=20
> < SNIP >
>=20
>     > Note the deletion of drivers/scsi/libsrp.c + include/scsi/libsr=
p.h has
>     > been dropped from the above commit, as it looks like they where=
 changes
>     > specific to your local tree.
>    =20
>     > Please have a quick look, and let me know if anything doesn't l=
ook
>     > right.
>=20
> So the deletion is from James suggesting that I revert the deletion o=
f libsrp to make
> It clear that the code used to exist in the kernel and that im bringi=
ng it back for this driver.
> Thus yeah you are right to not include it since those files don=E2=80=
=99t exist currently.
>=20

Thanks for the confirmation.  It should get picked up for today's
linux-next build by SFR & Co, so let's see if any build or merge issues
come up.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
