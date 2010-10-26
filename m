From: Ron Pitts <aussieron@gmail.com>
Subject: Highpoint raid not supported in linux
Date: Wed, 27 Oct 2010 07:04:52 +1100
Message-ID: <AANLkTimUtPd+xPJsNPAg6t+yDXduURtjjXYxF5pRVVFs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65510 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0JZUEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 16:04:52 -0400
Received: by iwn10 with SMTP id 10so2552794iwn.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 13:04:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

No joy with Highpoint support and no luck here...so I guess highpoint
have gone to the low ground.....

>
>
> I'm trying to load the hptiop driver within Fedora V13 and its currently
> returning scsi11: firmware not ready.
>
> I've located the section of code below:
>
>
> hptiop.c
>
>  if (hba->ops->iop_wait_ready(hba, 20000)) {
> 1017                 printk(KERN_ERR "scsi%d: firmware not ready\n",
> 1018                                 hba->host->host_no);
> 1019                 goto unmap_pci_bar;
> 1020         }
>
> What does this mean?  Faulty raid card?
>
