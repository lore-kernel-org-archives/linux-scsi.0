From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 20/37] smartpqi: add ptraid support
Date: Tue, 25 Apr 2017 20:13:18 +0000
Message-ID: <1493151197.2628.19.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314967409.13903.2226976663275826120.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52027 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1949626AbdDYUNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 16:13:22 -0400
In-Reply-To: <149314967409.13903.2226976663275826120.stgit@brunhilda>
Content-Language: en-US
Content-ID: <D1E47DE7386D0A47BB2BB526F87E4773@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
> +static inline bool pqi_is_external_raid_device(struct pqi_scsi_dev *devi=
ce)
> +{
> +	return device->is_external_raid_device;
> +}

The name of this function is almost as long as its implementation. Please d=
rop
this function definition and inline the function into its callers.

Thanks,

Bart.=
