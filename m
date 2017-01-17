From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 08/12] qla2xxx: Add framework for Async fabric
 discovery.
Date: Tue, 17 Jan 2017 22:27:08 +0000
Message-ID: <1484692014.2729.21.camel@sandisk.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
         <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0064.outbound.protection.outlook.com ([104.47.42.64]:22560
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750863AbdAQW1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 17:27:17 -0500
In-Reply-To: <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <BD762D49C178E442AA7CD4DC2DF24E67@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Mon, 2017-01-16 at 12:35 -0800, Himanshu Madhani wrote:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kref_get(&sess->sess_kref);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!kref_get_unless_zero(&=
sess->sess_kref)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ql_=
dbg(ql_dbg_tgt_tmr, vha, 0xffff,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "%s: kref_get fail %8pHC \n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 __func__, sess->port_name);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ses=
s =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o out_term2;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}

As far as I know %pH is not a valid conversion identifier. Was perhaps
%phC intended?.

Bart.=
