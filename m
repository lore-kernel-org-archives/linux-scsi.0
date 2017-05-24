From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/15] qedf: Honor qed_ops->common->set_fp_int() return
 code.
Date: Wed, 24 May 2017 16:22:23 +0000
Message-ID: <1495642942.2823.16.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-4-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14773 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764663AbdEXQWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:22:31 -0400
In-Reply-To: <20170523131931.1777-4-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <4EFFF15072551444883E23F069BF8375@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> We need to check the return code the set_fp_int() callback in case we wer=
e
> not allocated any fastpath interrupts or there was an error setting up th=
e
> fastpath interrupts from the qed perspective.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
