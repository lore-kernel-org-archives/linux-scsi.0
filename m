From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/20] [SCSI] remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 11:55:28 -0700
Message-ID: <1379962528.2109.6.camel@dabdike.int.hansenpartnership.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41475 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab3IWSzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Sep 2013 14:55:31 -0400
In-Reply-To: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org

On Mon, 2013-09-23 at 09:54 +0900, Jingoo Han wrote:
> Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata =3D NULL when no driver is bound),
> the driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.

Look, these are particularly pointless patches.  The null setting is
only on teardown; the fact that we set something to NULL that should
already be null doesn't matter at all the extra cycles simply won't be
noticed.  Please roll them into a single patch and send them to Ji=C5=99=
=C3=AD
Kosina and the trivial tree (cc'd) he'll take care of checking and
applying them (assuming they meet his criteria for worth bothering
with).

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
