From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv6 3/8] scsi: always send command aborts
Date: Mon, 10 Apr 2017 23:56:35 +0000
Message-ID: <1491868594.4199.31.camel@sandisk.com>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
         <1491485796-44411-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8158 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbdDJX4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 19:56:39 -0400
In-Reply-To: <1491485796-44411-4-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <A4DEB720A250424081BC6FF244455D3E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-04-06 at 15:36 +0200, Hannes Reinecke wrote:
> When a command has timed out we always should be sending an
> abort; with the previous code a failed abort might signal
> SCSI EH to start, and all other timed out commands will
> never be aborted, even though they might belong to a
> different ITL nexus.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
