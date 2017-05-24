From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 07/15] qedf: Set qed logging level to QED_LEVEL_NOTICE.
Date: Wed, 24 May 2017 16:35:22 +0000
Message-ID: <1495643721.2823.22.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-8-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37939 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933016AbdEXQfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:35:24 -0400
In-Reply-To: <20170523131931.1777-8-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <BF8B344CE248A349BC88556F259E76A1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> Reduce the logging level we set for qed messages pertaining to this PCI
> function so that unnecessary messages are not printed in the kernel
> message log.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
