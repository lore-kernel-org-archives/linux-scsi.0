From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: DIF/DIX in mpt3sas
Date: Thu, 30 Jun 2016 09:00:01 +0530
Message-ID: <6d015b6be722fc5ec949b8b1b19eb8a5@mail.gmail.com>
References: <59D68167-CD5A-4CD6-8382-7DA70A4B268C@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34972 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcF3DaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2016 23:30:03 -0400
Received: by mail-qk0-f177.google.com with SMTP id a125so123963453qkc.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 20:30:02 -0700 (PDT)
In-Reply-To: <59D68167-CD5A-4CD6-8382-7DA70A4B268C@umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoquan Zhang <zhan4281@umn.edu>, linux-scsi@vger.kernel.org
Cc: Alireza Haghdoost <haghdoost@gmail.com>, du <du@cs.umn.edu>, Raghu Raja Chandrasekar <raghu@cray.com>

Zhang,
 Thanks for your email.

DIX is supported in mpt3sas , but not by default and hence while loading
mpt3sas driver set module parameter "prot_mask=0x7F" to enable DIX
support.

Thanks,
 Chaitra

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Baoquan Zhang
Sent: Thursday, June 30, 2016 6:27 AM
To: linux-scsi@vger.kernel.org
Cc: Alireza Haghdoost; du; Raghu Raja Chandrasekar
Subject: DIF/DIX in mpt3sas

Hi there,

Thanks for reading my email.

I am a Ph.D student of University of Minnesota, Twin Cities. Recently, I
am working on a project of T10 PI-capable MD module. However, I fail to
use DIX with the HBA/driver combination of LSI Logic / Symbios Logic
SAS3008 PCI-Express Fusion-MPT SAS-3 (rev 02) /mpt3sas even though I have
formatted the drives with DIF protection type 1. May I know if DIX (data
integrity extension) is supported in mpt3sas driver?

Thanks,
Baoquan Zhang--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
