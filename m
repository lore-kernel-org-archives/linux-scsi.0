From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 00/12] qla2xxx: Feature updates for target.
Date: Thu, 19 Jan 2017 23:03:09 +0000
Message-ID: <1484866972.2634.10.camel@sandisk.com>
References: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0069.outbound.protection.outlook.com ([104.47.41.69]:5341
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751220AbdASXU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 18:20:27 -0500
In-Reply-To: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <D04766C34AD4CF4BBE9C72DD16A4650C@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Wed, 2017-01-18 at 15:19 -0800, Himanshu Madhani wrote:
> Changes from v2 --> v3
>=20
> o Cleaned up sparse warnings reported by you.

Not all warnings have been addressed. I still see the following smatch
warnings:

  CHECK   drivers/scsi/qla2xxx/qla_init.c
drivers/scsi/qla2xxx/qla_init.c:265: qla2x00_async_logout() error: we previ=
ously assumed 'sp' could be null (see line 241)

  CHECK   drivers/scsi/qla2xxx/qla_isr.c
drivers/scsi/qla2xxx/qla_isr.c:1456: qla2x00_ct_entry() warn: inconsistent =
indenting

The second warning is minor but is easy to address. The first one is
serious and applies to the following code: if (!sp) ... sp->....
Please address these smatch warnings.

Thanks,

Bart.=
