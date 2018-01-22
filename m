From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [RFC 0/2] mpt3sas/megaraid_sas : irq poll and load balancing of
 reply queue
Date: Mon, 22 Jan 2018 17:03:15 +0530
Message-ID: <a75d5260fff6377ce193c7f417e8052f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:43801 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAVLdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 06:33:19 -0500
Received: by mail-io0-f178.google.com with SMTP id 72so9089129iom.10
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2018 03:33:19 -0800 (PST)
References: 92d894a263bf37152fdae9699ccaccff@mail.gmail.com
In-Reply-To: 92d894a263bf37152fdae9699ccaccff@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

>
> In Summary,
> CPU completing IO which is not contributing to IO submission, may cause
cpu
> lockup.
> If CPUs count to MSI-X vector count ratio is X:1 (where X > 1) then
using irq poll
> interface, we can avoid the CPU lockups and by equally distributing the
> interrupts among the enabled MSI-x interrupts we can avoid performance
> issues.
>
> We are planning to use both the fixes only if cpu count is more than FW
> supported MSI-x vector.
> Please review and provide your feedback. I have appended both the
patches.

Hi -
Assuming method explained here is in-line with Linux SCSI subsystem and
there is no better method to fix such issue.
I am planning to provide the same solution for internal testing and
maintainers of respective driver (mpt3sas and megaraid_sas) will post
final patch to the upstream based on results.
As of now PoC results looks promising with the above mentioned solution
and no cpu lock was discovered.

>
> Thanks, Kashyap
>
>
