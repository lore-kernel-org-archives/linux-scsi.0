From: Eero Volotinen <eero.volotinen@iki.fi>
Subject: mtpbase ioc error codes?
Date: Tue, 25 Oct 2011 12:15:20 +0300
Message-ID: <CABzZrXcCRP2q2q9C7x0NPJPjxy=wqUdm0_MDLLdYZ0chPoOoug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53956 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1JYJPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 05:15:20 -0400
Received: by ywm3 with SMTP id 3so290268ywm.19
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2011 02:15:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi List,

My server reports following failures to kernel:

mptbase: ioc0: WARNING - IOC is in FAULT state (1600h)!!!

mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 1600h

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success

mptbase: ioc0: WARNING - IOC is in FAULT state (1600h)!!!

mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 1600h

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success

But I cannot find any description for this errorcode? It is broken
harddisk or raid card failure?

Thanks for any information.

br,
--
Eero
