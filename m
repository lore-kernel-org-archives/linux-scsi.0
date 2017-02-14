From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH] snic: switch to pci_irq_alloc_vectors
Date: Tue, 14 Feb 2017 19:34:45 +0000
Message-ID: <D4C95893.8CEC7%nmusini@cisco.com>
References: <1485958881-17367-1-git-send-email-hch@lst.de>
 <yq1zihysvki.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:34913 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754045AbdBNToZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 14:44:25 -0500
In-Reply-To: <yq1zihysvki.fsf@oracle.com>
Content-Language: en-US
Content-ID: <5029F8FBDF79FE45AA2B101D28AD42DB@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,
    Thanks for the changes. Looks good. Verified.
Acked-by: Narsimhulu Musini <nmusini@cisco.com>



Thanks
simha
On 07/02/17 5:47 am, "Martin K. Petersen" <martin.petersen@oracle.com>
wrote:

>>>>>> "Christoph" =3D=3D Christoph Hellwig <hch@lst.de> writes:
>
>Narsimhulu,
>
>Please test and review!
>
>	https://patchwork.kernel.org/patch/9549801/
>
>--=20
>Martin K. Petersen	Oracle Linux Engineering
