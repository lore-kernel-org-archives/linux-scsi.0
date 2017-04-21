From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/9] sd: Fix functions description
Date: Fri, 21 Apr 2017 17:28:30 +0000
Message-ID: <1492795708.2550.19.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35013 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036878AbdDUSfs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 14:35:48 -0400
In-Reply-To: <20170421091649.25287-3-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <D248C74CCBECD243A3A01925D4051403@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> - *	Returns 0 if successful. Returns a negated errno value in case
> - *	of error.
> + * Returns 0 if successful. Returns a negated errno value in case
> + * of error.

Hello Damien,

The argument name fixes are definitely welcome in my opinion. But I see
that this patch not only fixes argument names and function descriptions
but also includes whitespace-only changes like the above. Sorry but I
don't like=A0whitespace-only changes ...

Bart.=
