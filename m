From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 00/31] SCSI patches for kernel v4.13.
Date: Thu, 1 Jun 2017 14:08:04 +0000
Message-ID: <1496326082.3075.3.camel@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
         <yq1o9uhsnco.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32847 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdFAOIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 10:08:07 -0400
In-Reply-To: <yq1o9uhsnco.fsf@oracle.com>
Content-Language: en-US
Content-ID: <6C17A57715A75940BB773862334A4545@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Wed, 2017-05-24 at 22:04 -0400, Martin K. Petersen wrote:
> > This patch series consists of the bug fixes I came up with during the
> > past two months. Please consider these patches for kernel v4.13.
>=20
> No major objections from me. Although you may have to slice and dice the
> series differently so we can get the block bits queued through Jens and
> then do the rest as a stage 2 merge.

Hello Martin,

The first eight patches in this series do not depend on any block layer cha=
nges.
Do you want me to repost this patches or can you perhaps queue these withou=
t a
repost?

Thanks,

Bart.=
