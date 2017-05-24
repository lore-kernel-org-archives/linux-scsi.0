From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 13/15] qedf: Change cmd_per_lun in scsi_host_template to
 32 to increase performance.
Date: Wed, 24 May 2017 16:43:46 +0000
Message-ID: <1495644225.2823.31.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-14-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30571 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967839AbdEXQns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:43:48 -0400
In-Reply-To: <20170523131931.1777-14-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <BC786CBC50D31F43A6BE86CF0BF7B370@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> Increase the default number of commands that the driver tells the
> SCSI mid-layer it can do to increase the default performance of the
> driver.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
