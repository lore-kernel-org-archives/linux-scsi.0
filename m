From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] fnic: Adding Check Condition counter to misc fnicstats
Date: Thu, 23 Mar 2017 09:59:54 -0400
Message-ID: <yq18tnwf605.fsf@oracle.com>
References: <1488327344-8817-1-git-send-email-satishkh@cisco.com>
        <yq14lzcqt0o.fsf@oracle.com>
        <29e530689cd247b9a6ab377fc5f71dfd@XCH-RCD-012.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42126 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933119AbdCWOAk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 10:00:40 -0400
In-Reply-To: <29e530689cd247b9a6ab377fc5f71dfd@XCH-RCD-012.cisco.com> (Satish
        Kharat's message of "Thu, 23 Mar 2017 00:03:28 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Satish Kharat (satishkh)" <satishkh@cisco.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, Christoph Hellwig <hch@infradead.org>

"Satish Kharat (satishkh)" <satishkh@cisco.com> writes:

Satish,

> Apologies for the delay. I was not able to verify this because of
> another fnic issue blocking this test. Just now submitted a fix for
> that 'fnic issue' (in the patch => [PATCH 1/1] fnic: bug fix for
> fip.fip_subcode in fnic_fcoe_send_vlan_req)
>
> Did some quick verification and basic IO test, this patch looks good.

OK, I have applied your patches as well as Christoph's
pci_alloc_irq_vectors() change to 4.12/scsi-queue.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
