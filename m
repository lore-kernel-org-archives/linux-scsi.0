From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv6 2/8] sd: Return SUCCESS in sd_eh_action() after device
 offline
Date: Mon, 10 Apr 2017 23:54:08 +0000
Message-ID: <1491868447.4199.30.camel@sandisk.com>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
         <1491485796-44411-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58115 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdDJXyN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 19:54:13 -0400
In-Reply-To: <1491485796-44411-3-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <E9E85F2C0B0C604CB4B08FDD7B643CE5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-04-06 at 15:36 +0200, Hannes Reinecke wrote:
> If sd_eh_action() decides to take the device offline there is
> no point in returning FAILED, as taking the device offline
> is the ultimate step in SCSI EH anyway.
> So further escalation via SCSI EH is not likely to make a
> difference and we can as well return SUCCESS.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
