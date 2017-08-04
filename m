From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_dh_alua: suppress errors from unsupported devices
Date: Fri, 4 Aug 2017 15:56:18 +0000
Message-ID: <1501862177.2757.12.camel@wdc.com>
References: <1501828660-89497-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38511 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbdHDP5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 11:57:01 -0400
In-Reply-To: <1501828660-89497-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <5166812C3F56314391C81B764498BB15@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-08-04 at 08:37 +0200, Hannes Reinecke wrote:
> ALUA is only relevant for disk-like devices, so we shouldn't
> be printing out warning messages for other device types.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
