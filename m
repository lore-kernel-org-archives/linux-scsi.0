From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/2] scsi: sd: Remove LBPRZ dependency for discards
Date: Fri, 7 Apr 2017 18:36:53 +0000
Message-ID: <1491590212.2559.19.camel@sandisk.com>
References: <20170405114111.26864-1-martin.petersen@oracle.com>
         <20170405114111.26864-2-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43811 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932993AbdDGSgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 14:36:55 -0400
In-Reply-To: <20170405114111.26864-2-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <AE166FC2B86BF44B912B89384E214D9C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

On Wed, 2017-04-05 at 07:41 -0400, Martin K. Petersen wrote:
> Separating discards and zeroout operations allows us to remove the LBPRZ
> block zeroing constraints from discards and honor the device preferences
> for UNMAP commands.
>=20
> If supported by the device, we'll also choose UNMAP over one of the
> WRITE SAME variants for discards.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
