From: Ron Pitts <aussieron@gmail.com>
Subject: Re: Problem with RR3520 (HighPoint Raid) - Fedora -
Date: Sat, 23 Oct 2010 22:48:59 +1100
Message-ID: <AANLkTinK1-xJF+VxtC_w0wbCJAJbyjDisVy6dT+JxwJS@mail.gmail.com>
References: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36073 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0JWLs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 07:48:59 -0400
Received: by iwn34 with SMTP id 34so2058658iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 23 Oct 2010 04:48:59 -0700 (PDT)
In-Reply-To: <AANLkTimVsA-_Z=LgL4pOVc1uY7bB1nwDSbRMZwdWZNpy@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to load the hptiop driver within Fedora V13 and its
currently returning scsi11: firmware not ready.

 I've located the section of code below:

 =A0 hptiop.c

=A0if (hba->ops->iop_wait_ready(hba, 20000)) {
> 1017=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_ERR =
"scsi%d: firmware not ready\n",
> 1018=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hba->host->host_no);
> 1019=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unmap_pci_b=
ar;
> 1020=A0=A0=A0=A0=A0=A0=A0=A0 }

 What does this mean?=A0 Faulty raid card?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
