From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Mon, 20 Feb 2017 17:34:04 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA0A9972@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26839 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753434AbdBTReP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 12:34:15 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On 02/16/2017 04:20 PM, Damien Le Moal wrote:=0A=
> Move the partial completion alignement check of mpt3sas to a generic=0A=
> implementation in sd_done so that the check ignores REQ_TYPE_FS=0A=
> requests with special payload size handling (REQ_OP_DISCARD,=0A=
> REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET).=0A=
=0A=
Hello Damien,=0A=
=0A=
Since the resid adjustment code is skipped for REQ_OP_DISCARD and=0A=
REQ_OP_WRITE_SAME: does the mpt3sas firmware ensure that 'resid' is=0A=
properly aligned for these request types? Did I perhaps miss something?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
=0A=
=0A=
