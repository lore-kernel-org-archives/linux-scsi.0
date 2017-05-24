From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 14/15] qedf: Add change_queue_depth member to
 scsi_host_template().
Date: Wed, 24 May 2017 16:44:08 +0000
Message-ID: <1495644247.2823.32.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-15-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53733 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967885AbdEXQoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:44:11 -0400
In-Reply-To: <20170523131931.1777-15-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <D7EB242A87372646BE5CAAFDD4F6D437@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> Add the change_queue_depth member to our SCSI host template so the queue
> depth of devices attached to qedf can be changed dynamically.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
