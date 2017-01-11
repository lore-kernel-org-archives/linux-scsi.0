From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/11] qla2xxx: Make trace flags more readable.
Date: Wed, 11 Jan 2017 20:47:01 +0000
Message-ID: <1484167606.2619.23.camel@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
         <1482553419-4117-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:2800
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756346AbdAKUrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 15:47:11 -0500
In-Reply-To: <1482553419-4117-4-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <6B6895C56ACEAC4CAE08BEA1F3A7FD12@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Fri, 2016-12-23 at 20:23 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> This patch does not change any functionality.

Please also mention in the patch description what the purpose of cmd_flags
is. If I remember correctly the only purpose of most flags is to make
analyzing crash dumps easier?

Bart.=
