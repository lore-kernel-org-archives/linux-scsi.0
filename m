From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 5/14] megaraid_sas: Fix probe_one to clear MSI-X flags in kdump
Date: Thu, 31 Mar 2011 11:50:30 -0700
Message-ID: <AANLkTim2KJV9iz5SCExNfKD_Z+y6Nj34n3hE_jLhupr7@mail.gmail.com>
References: <AANLkTimG4HbXCNUdkcpGHbP7D2oNmvymbyKMOkCFNxJD@mail.gmail.com>
	<4D93227E.4040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43326 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1CaSub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 14:50:31 -0400
Received: by wwa36 with SMTP id 36so3177541wwa.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 11:50:30 -0700 (PDT)
In-Reply-To: <4D93227E.4040407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Wed, Mar 30, 2011 at 5:30 AM, Tomas Henzl <thenzl@redhat.com> wrote:

> Hi Adam,
> sorry I'm late, but this is still not applied I think.

Yes, it is here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=66192dfe1e74eae31a76cfc36092dabdba1324e6

>
> The above #define are already defined in msi.h and pci_regs.h
> I'd prefer to include those files instead of define the values.
>

msi_control_reg() macro is defined in drivers/pci/msi.h _not_
include/linux/msi.h.

Are you suggesting I try to include drivers/pci/msi.h ?

-Adam
