From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 01/35] scsi: fix comment in scsi_device_set_state()
Date: Fri, 23 Jun 2017 15:56:16 +0000
Message-ID: <1498233375.2735.0.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45447 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdFWP4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 11:56:19 -0400
In-Reply-To: <1498222975-71858-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <68816B2335007A48B3E353ABFF77E270@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> The function returns '0' if successful; with the original comment
> the function doesn't have a way to indicate success ...

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
