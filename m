From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 1/4] scsi_dh_alua: Do not modify the interval value for
 retries
Date: Fri, 12 May 2017 16:25:17 +0000
Message-ID: <1494606315.14477.4.camel@sandisk.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23632 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757439AbdELQZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2017 12:25:19 -0400
In-Reply-To: <20170512131508.3231-2-mwilck@suse.com>
Content-Language: en-US
Content-ID: <AAF7836A43729E4EBF821658E5F42642@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-12 at 15:15 +0200, Martin Wilck wrote:
> From: Hannes Reinecke <hare@suse.de>
>=20
> We shouldn't set the interval value to 0 in alua_rtpg_work(), as the stru=
ct
> is accessed from different devices and hence we might end up scheduling
> too early.
>=20
> With this change, pg->interval is now effectively constant, thus we might
> as well replace it with a contant expression.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
