From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 34/35] scsi: Move eh_device_reset_handler() to use
 scsi_device as argument
Date: Fri, 23 Jun 2017 18:44:29 +0000
Message-ID: <1498243468.2735.17.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-35-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30371 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 14:44:32 -0400
In-Reply-To: <1498222975-71858-35-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <6050EDDA4D918F4C9F44175394261193@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> When resetting a device we shouldn't depend on an existing SCSI
> device, so use 'struct scsi_device' as argument for
> eh_device_reset_handler().

Did you perhaps mean "existing SCSI command"?

Also for this patch, I'm not familiar enough with all the SCSI LLDs that
have been modified to do an in-depth review. But since I agree with the
direction of this patch:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
