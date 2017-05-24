From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 04/15] qedf: Look at all descriptors when processing a
 clear virtual link.
Date: Wed, 24 May 2017 16:24:35 +0000
Message-ID: <1495643074.2823.17.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-5-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8062 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbdEXQYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:24:37 -0400
In-Reply-To: <20170523131931.1777-5-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <EF78C3B22CFD0243B5B06456D7083999@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> If there are multiple descriptors for a particular type in a clear virtua=
l
> link we receive, we will not process it correctly but rather take the las=
t
> value. This can cause us not to not flap the virtual link as the value fr=
om
> the descriptors that we compare against the our stored FCF or fc_lport va=
lues
> may not match.
>=20
> Change is to do a comparison when processing the each descriptor instead =
of at
> the end and then set a bool if we need to do the reset.

Did you perhaps mean "Change this" instead of "Change is"? Anyway:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
