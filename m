From: Olaf Hering <olh@suse.de>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 15:27:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928132744.GA29838@suse.de>
References: <4159611C.4030106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:18330 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267810AbUI1N15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:27:57 -0400
Content-Disposition: inline
In-Reply-To: <4159611C.4030106@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

 On Tue, Sep 28, Luben Tuikov wrote:

> diff -ruN -X exclude-files=20
> linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic79xx=20
> linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx
> --- linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic79xx	2004-09-27=20
> 09:41:42.849518248 -0400
> +++ linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx	2003-03-10=20
> 19:12:41.000000000 -0500

you should diff in the other direction.
And fix your mailer.


--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
