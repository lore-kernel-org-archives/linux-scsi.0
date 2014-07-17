From: Peter Andersson <peter@turbin.se>
Subject: megasas: failed to get PD list
Date: Thu, 17 Jul 2014 20:31:20 +0200
Message-ID: <53C81678.2010600@turbin.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:39919 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaGQSbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2014 14:31:53 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so2040693lam.14
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2014 11:31:51 -0700 (PDT)
Received: from Peters-Mac-Pro.local (c-5621e555.010-118-73746f10.cust.bredbandsbolaget.se. [85.229.33.86])
        by mx.google.com with ESMTPSA id n1sm4668882lbs.0.2014.07.17.11.31.49
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 17 Jul 2014 11:31:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi.
I'm having major problems with my "MegaRAID SAS 9240-81" raid 
controller. Basically the kernel doesn't find my raid drives.

Bios version: 4.38.02.0 (January 16 2014)
The bios of the raid controller shows a fully working (and initialized) 
raid 0.

Kernel: 3.15.1-031501-generic (ubuntu server 14.04)

This is the full dmesg regarding the card:

[    0.902723] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    0.902788] megasas: 0x1000:0x0073:0x1000:0x9240: bus 3:slot 0:func 0
[    0.903121] megasas: FW now in Ready state
[    0.903180] megaraid_sas 0000:03:00.0: irq 80 for MSI/MSI-X
[    0.903188] megaraid_sas 0000:03:00.0: [scsi0]: FW supports<0> MSIX 
vector,Online CPUs: <12>,Current MSIX <1>
[    0.924336] megasas_init_mfi: fw_support_ieee=67108864
[    0.924372] megasas: INIT adapter done
[   72.855404] megasas: failed to get PD list

lspci:
03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2008 
[Falcon] (rev 03)

megaraidsas-status:
-- Arrays informations --
-- ID | Type | Size | Status

-- Disks informations
-- ID | Model | Status | Warnings

After the drives are initialized i also get this message:
Virtual drive handled by bios

That's all i can think to be of interest to you.
Could anyone give me some pointers on what could be wrong?

Thanks!

/Peter
