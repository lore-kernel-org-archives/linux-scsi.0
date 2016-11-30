From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] qla4xxx: switch to pci_alloc_irq_vectors
Date: Wed, 30 Nov 2016 06:08:33 +0000
Message-ID: <D4646975.42B99%nilesh.javali@cavium.com>
References: <1479453321-18036-1-git-send-email-hch@lst.de>
 <yq1r35unsku.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0062.outbound.protection.outlook.com ([104.47.40.62]:50928
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751432AbcK3Gkz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 01:40:55 -0500
In-Reply-To: <yq1r35unsku.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Content-ID: <B93002A98603A84892162A3B2C03C209@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,

We would test this internally and then ACK within a week.

Thanks,
Nilesh

On 29/11/16, 10:15 PM, "Martin K. Petersen" <martin.petersen@oracle.com>
wrote:

>>>>>> "Christoph" =3D=3D Christoph Hellwig <hch@lst.de> writes:
>
>Christoph> And simplify the MSI-X logic in general - just request the
>Christoph> two vectors directly instead of going through an indirection
>Christoph> table.
>
>Vikas: Please review!
>
>--=20
>Martin K. Petersen	Oracle Linux Engineering

