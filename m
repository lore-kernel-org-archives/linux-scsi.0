From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 00/10] qla2xxx: Bug fixes for driver.
Date: Tue, 17 Jan 2017 18:25:15 +0000
Message-ID: <1484677492.2729.2.camel@sandisk.com>
References: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr730085.outbound.protection.outlook.com ([40.107.73.85]:25216
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdAQSoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 13:44:23 -0500
In-Reply-To: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <6B7298E2C9BD3247A057ED8324BB06DB@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Fri, 2016-12-23 at 18:06 -0800, Himanshu Madhani wrote:
> Here's updated series of bug fixes for target code in the driver.
> Please consider this for target-pending.

Hello Himanshu,

Thanks for the patches. I have queued these patches for v4.10-rc5. But sinc=
e
the qla2xxx driver code triggers several static checker warnings, I would
appreciate if you could have a look at the four patches I just posted to
address these warnings.

Bart.=
