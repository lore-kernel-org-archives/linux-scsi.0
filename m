From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol
 dependency
Date: Fri, 16 Dec 2016 09:49:00 +0100
Message-ID: <fc570beb-929f-0c37-718a-b786ab63e4d7@sandisk.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
 <20161214211823.GC14133@infradead.org>
 <8A5A0387-B871-4E64-9439-5C936947E1F8@cavium.com>
 <323E0F97-56EE-4EB4-A204-B824BDE8B1D5@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:33795 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754671AbcLPIvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2016 03:51:03 -0500
In-Reply-To: <323E0F97-56EE-4EB4-A204-B824BDE8B1D5@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tran, Quinn" <Quinn.Tran@cavium.com>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/15/2016 09:50 PM, Tran, Quinn wrote:
> Qlogic was asked to support other Target Stack (SCST) using the same
> qla2xxx.ko upstream driver.  I had mentioned this during the last 2015
> LSF get together.  Hopefully, that gives a better context.  The
> understanding that came away was “Qlogic do what is needed to provide
> this support without creating any dead code”.
>
> [ ... ]
>
> The patches look like its copying a lot of fields without doing a whole
> lot, instead the patches are translating the request from tcm_qla2xxx to
> qla2xxx.

Hello Quinn,

Are you perhaps referring to the 2015 LSF/MM session I had proposed
([LSF/MM TOPIC] Unifying the LIO and SCST target drivers -
https://marc.info/?l=linux-scsi&m=142122995413575)? The approach taken
in patch 08/22 of this series is not what I had in mind. More in
general, as you maybe know shim (translation) layers are not welcome in
the Linux kernel.

Simplifying the LIO core is still on my to do list. A possible starting
point is the patch series I posted one year ago ([PATCH 00/20] SCSI
target patches for kernel v4.4 -
https://www.spinics.net/lists/target-devel/msg10788.html). That kind of
simplification helps with reducing the maintenance burden for target
drivers that support the two in-kernel SCSI target stacks without
violating any of the established rules for kernel driver development.

Bart.
