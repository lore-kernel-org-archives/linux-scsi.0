From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/1] scsi: scsi_debug: Avoid PI being disabled when TGPS
 is enabled
Date: Wed, 31 May 2017 15:05:37 +0000
Message-ID: <1496243136.2608.0.camel@sandisk.com>
References: <20170526165935.19543-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62426 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdEaPFj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 11:05:39 -0400
In-Reply-To: <20170526165935.19543-1-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <EF1334AD921F6446AE636484CF94BB88@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-05-26 at 12:59 -0400, Martin K. Petersen wrote:
> It was not possible to enable both T10 PI and TGPS because they share
> the same byte in the INQUIRY response. Logically OR the TPGS value
> instead of using assignment.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
