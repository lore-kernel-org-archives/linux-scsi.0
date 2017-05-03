From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH RFC] scsi: wait sd probing in manual scan
Date: Wed, 3 May 2017 18:15:02 +0000
Message-ID: <1493835300.3901.28.camel@sandisk.com>
References: <1493365699-25566-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49535 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdECSPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 14:15:07 -0400
In-Reply-To: <1493365699-25566-1-git-send-email-bergwolf@gmail.com>
Content-Language: en-US
Content-ID: <1FCFADC3DCCDA04C80F4BDF7D6F28B89@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bergwolf@gmail.com" <bergwolf@gmail.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-04-28 at 15:48 +0800, Peng Tao wrote:
> We have a guest init programe trying to mount a device after doing scsi h=
ost scan
> at boot time. Occasionally it fails to find the device when mounting. Aft=
er digging
> a bit, it seems the root cause is sd async_schedule probing.
>=20
> With async probing, there is no guarantee of device readiness when scsi h=
ost
> scan finishes. However, users do expect to have a valid way to make sure =
device
> is usable. Change scsi scan to wait sd probing in manual scan case so tha=
t we
> don't leave user with random device state when scsi host scan returns.
>=20
> Is this the right way to have such guarantee?

Hello Peng,

Please fix the guest init program such that it waits until the SCSI device
it needs is ready.

Thanks,

Bart.=
