From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Wed, 27 Sep 2017 19:26:02 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B8D13DE@avsrvexchmbx2.microsemi.net>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
        <423FD6710FB8FB4F8728F93591889F9A5B8CD1FA@avsrvexchmbx2.microsemi.net>
        <b15b69e2-0d41-56cd-2952-a214d7ad7973@linux.vnet.ibm.com>
 <yq1fubafooe.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0043.outbound.protection.outlook.com ([104.47.32.43]:27630
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751552AbdI0T0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 15:26:12 -0400
In-Reply-To: <yq1fubafooe.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "dougmill@linux.vnet.ibm.com" <dougmill@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>


>=20
>=20
> Guilherme,
>=20
> > James/Martin, am I expected to send a v2 with some change? Perhaps
> > with Dave's ack?  Sorry to annoy, thanks in advance for any advice!
>=20
> I was just about to mail Dave and ask for confirmation that your interpre=
tation
> of the controller behavior is correct.
>=20
> Dave?
>=20
 Hi Martin,

Previously we had used sleep to delay until the controller got its mind bac=
k,=20
but early testing indicated it wasn't needed. I'm  good with this.

-Dave
