From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 2/4] scsi_dh_alua: Do not retry for unmapped device
Date: Fri, 12 May 2017 16:26:21 +0000
Message-ID: <1494606380.14477.5.camel@sandisk.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15310 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757961AbdELQ0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2017 12:26:24 -0400
In-Reply-To: <20170512131508.3231-3-mwilck@suse.com>
Content-Language: en-US
Content-ID: <8EC7279BF213774B8F70940E7ED01D9C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-12 at 15:15 +0200, Martin Wilck wrote:
> From: Hannes Reinecke <hare@suse.de>
>=20
> If a device becomes unmapped on the target we should be returning
> SCSI_DH_DEV_OFFLINED.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
