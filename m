From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Fri, 3 Feb 2017 16:59:59 +0000
Message-ID: <1486141186.2553.2.camel@sandisk.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
         <20170123163446.9227-2-bart.vanassche@sandisk.com>
         <yq1tw8mbtyj.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0079.outbound.protection.outlook.com ([104.47.42.79]:25760
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750828AbdBCRAH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 12:00:07 -0500
In-Reply-To: <yq1tw8mbtyj.fsf@oracle.com>
Content-Language: en-US
Content-ID: <3C35FFB2F1D2BB41AFC4E82CAA7CCCE4@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michael.hernandez@cavium.com" <michael.hernandez@cavium.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "hch@lst.de" <hch@lst.de>

On Wed, 2017-01-25 at 18:28 -0500, Martin K. Petersen wrote:
> > > > > > "Bart" =3D=3D Bart Van Assche <bart.vanassche@sandisk.com> writ=
es:
>=20
> Bart> qla2x00_probe_one() allocates IRQs before it initializes rsp_q_map
> Bart> so IRQs must be freed even if rsp_q_map allocation did not occur.
> Bart> This was detected by kmemleak.
>=20
> I queued this one yesterday but was waiting for a resolution on patch
> 2...

Hello Martin,

Since there is now a resolution for patch 2: have you already decided when
to submit these patches upstream?

Thanks,

Bart.=
