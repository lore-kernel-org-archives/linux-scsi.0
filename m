From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv5 0/2] tcmu: For bugs fix only
Date: Thu, 30 Mar 2017 15:03:40 +0000
Message-ID: <1490886207.2753.1.camel@sandisk.com>
References: <1490605661-16127-1-git-send-email-lixiubo@cmss.chinamobile.com>
         <1490863702.6977.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31743 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932971AbdC3PEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 11:04:23 -0400
In-Reply-To: <1490863702.6977.7.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <294CA701478CF14090B443C19DFCF3CD@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lixiubo@cmss.chinamobile.com" <lixiubo@cmss.chinamobile.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>, "agrover@redhat.com" <agrover@redhat.com>, "iliastsi@arrikto.com" <iliastsi@arrikto.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "shli@kernel.org" <shli@kernel.org>, "sheng@yasker.org" <sheng@yasker.org>, "namei.unix@gmail.com" <namei.unix@gmail.com>, "mchristi@redhat.com" <mchristi@redhat.com>

On Thu, 2017-03-30 at 01:48 -0700, Nicholas A. Bellinger wrote:
> Just for future reference, the flow of these tags should reflect the
> history of the patch.  Eg:
>=20
> Reviewed-by: First reviewer <foo@bar.com>
> Tested-by: First tester <foo2@bar2.com>
> Reviewed-by: Second reviewer <foo3@bar3.com>
> Signed-off-by: Patch Author <you@yourdomain.com>
>=20
> and then once the subsystem maintainer merges it into his tree, they add
> their own:
>=20
> Signed-off-by: Subsystem Maintainer <superturboarray@linux-domain.org>

Hi Nic,

I agree that these tags should reflect the history of the patch. I think
that means that the patch author should be mentioned first, Reviewed-by /
Tested-by tags next and the subsystem maintainer sign-off last. At least,
that's how most other maintainers do it.

Bart.=
