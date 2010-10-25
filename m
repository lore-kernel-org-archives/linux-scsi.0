From: Ron Pitts <aussieron@gmail.com>
Subject: Re: Problem with RR3520 (HighPoint Raid) - Fedora -
Date: Tue, 26 Oct 2010 06:27:03 +1100
Message-ID: <AANLkTi=ZH0YjSkU_DRZOg5usf4UtG=X_k1ffkEEHUXLf@mail.gmail.com>
References: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50910 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab0JYT1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 15:27:04 -0400
Received: by gyg4 with SMTP id 4so2330125gyg.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 12:27:03 -0700 (PDT)
In-Reply-To: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Any ideas?

On Sat, Oct 23, 2010 at 10:48 PM, Ron Pitts <aussieron@gmail.com> wrote=
:
>
>
> I'm trying to load the hptiop driver within Fedora V13 and its curren=
tly
> returning scsi11: firmware not ready.
>
> I've located the section of code below:
>
>
> hptiop.c
>
> =A0if (hba->ops->iop_wait_ready(hba, 20000)) {
> 1017=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_ERR =
"scsi%d: firmware not ready\n",
> 1018=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hba->host->host_no);
> 1019=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unmap_pci_b=
ar;
> 1020=A0=A0=A0=A0=A0=A0=A0=A0 }
>
> What does this mean?=A0 Faulty raid card?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
