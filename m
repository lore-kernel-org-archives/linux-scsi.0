From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH V2] st: fix potential null pointer dereference.
Date: Tue, 24 Nov 2015 21:59:15 +0200
Message-ID: <8391E202-28F1-4CCA-94AE-28C952770650@kolumbus.fi>
References: <1447857164-2043-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:49661 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbbKXT7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 14:59:20 -0500
In-Reply-To: <1447857164-2043-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


> On 18.11.2015, at 16.32, Maurizio Lombardi <mlombard@redhat.com> wrot=
e:
>=20
> If cdev_add() returns an error, the code calls
> cdev_del() passing the STm->cdevs[rew] pointer as parameter;
> the problem is that the pointer has not been initialized yet.
>=20
> This patch fixes the problem by moving the STm->cdevs[rew] pointer
> initialization before the call to cdev_add().
> It also sets STm->devs[rew] and STm->cdevs[rew] to NULL in
> case of failure.
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
