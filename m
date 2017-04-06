From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Make checking the scsi_device_get() return value
 mandatory
Date: Thu, 6 Apr 2017 00:30:43 +0000
Message-ID: <1491438642.2787.17.camel@sandisk.com>
References: <201704060817.vbFGWYzD%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44427 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbdDFAas (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 20:30:48 -0400
In-Reply-To: <201704060817.vbFGWYzD%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <73B7684C02853141AE4B6EF7A37A9BC8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, 2017-04-06 at 08:27 +0800, kbuild test robot wrote:
> All warnings (new ones prefixed by >>):
>=20
>    drivers//scsi/osd/osd_uld.c: In function 'osd_probe':
> > > drivers//scsi/osd/osd_uld.c:467:2: warning: ignoring return value of =
'scsi_device_get', declared with attribute warn_unused_result [-Wunused-res=
ult]
>=20
>      scsi_device_get(scsi_device);
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please ignore this warning. It is triggered because patch "osd_uld: Check
scsi_device_get() return value" is not yet upstream.

Bart.=
