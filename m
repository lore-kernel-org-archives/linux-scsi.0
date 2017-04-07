From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Fri, 7 Apr 2017 16:36:49 +0000
Message-ID: <1491583008.2559.12.camel@sandisk.com>
References: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
         <0c80c6e3-168a-d8bd-d7b4-e727723bcf18@sandisk.com>
         <5297a130-5349-1796-2fe4-2336daa346ab@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1414 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934248AbdDGQgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 12:36:54 -0400
In-Reply-To: <5297a130-5349-1796-2fe4-2336daa346ab@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <C6DD9E8D70F46549A5A35AB8C7AE6F2D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>

On Fri, 2017-04-07 at 11:12 -0500, Bryant G. Ly wrote:
> So from this stack trace it looks like the ibmvscsis driver is sending an
> extra response through send_messages even though an abort was issued. =20
> IBMi, reported this issue internally when they were testing the driver,
> because their client didn't like getting a response back for the aborted =
op.
> They are only expecting a TMR from the abort request, NOT the aborted op.=
=20

Hello Bryant,

What is the root cause of this behavior? Why is it that the behavior of
the ibmvscsi_tgt contradicts what has been implemented in the LIO core?
Sorry but the patch at the start of this thread looks to me like an
attempt to paper over the problem instead of addressing the root cause.

Thanks,

Bart.=
