From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 00/12] SCSI patches for kernel v4.13
Date: Fri, 2 Jun 2017 21:10:52 +0000
Message-ID: <1496437851.1214.20.camel@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
         <yq17f0ujdxf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42358 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdFBVKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:10:55 -0400
In-Reply-To: <yq17f0ujdxf.fsf@oracle.com>
Content-Language: en-US
Content-ID: <3FAC5FC82E66A34CB065A7EA5AD02AA0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hch@lst.de" <hch@lst.de>

On Fri, 2017-06-02 at 17:08 -0400, Martin K. Petersen wrote:
> > This patch series consists of the bug fixes and improvements I came up
> > with during the past two months. Please consider these patches for
> > kernel v4.13.
>=20
> Does this series have dependencies on stuff that went into block for
> 4.13?

Hello Martin,

This series does not have any dependencies on pending block layer changes
and applies fine on your 4.13/queue branch. BTW, I just finished addressing
the review comments posted on v2 and am ready to post v3 of this patch seri=
es.

Bart.=
