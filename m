From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 08/15] qedf: Use same logic for SCSI host reset and FC
 lip_reset.
Date: Wed, 24 May 2017 16:36:28 +0000
Message-ID: <1495643787.2823.23.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-9-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:7683 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035411AbdEXQgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:36:31 -0400
In-Reply-To: <20170523131931.1777-9-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <B97B8AA2553B0F40BF74C0A7C2CC598D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> We should be using the same logic to do a soft reset of the FCoE function
> whether it is initiated via sg_reset or the fc_host issue_lip attribute.
> Refactor the host reset and fcoe reset handlers to use the preferred logi=
c
> which is currently contained in qedf_eh_host_reset().

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
