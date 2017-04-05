From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi: sd: Fix capacity calculation with 32-bit
 sector_t
Date: Wed, 5 Apr 2017 18:13:45 +0000
Message-ID: <1491416024.2787.9.camel@sandisk.com>
References: <20170405101529.30787-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31824 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932598AbdDESNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 14:13:49 -0400
In-Reply-To: <20170405101529.30787-1-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <CFDCA15AD76E0A4780A0533FD12C2060@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, 2017-04-05 at 06:15 -0400, Martin K. Petersen wrote:
> We previously made sure that the reported disk capacity was less than
> 0xffffffff blocks when the kernel was not compiled with large sector_t
> support (CONFIG_LBDAF). However, this check assumed that the capacity
> was reported in units of 512 bytes.
>=20
> Add a sanity check function to ensure that we only enable disks if the
> entire reported capacity can be expressed in terms of sector_t.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
