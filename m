From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2 2/3] xen-scsiback: Rename jump labels in
 scsiback_device_action()
Date: Wed, 20 Jul 2016 13:45:19 +0200
Message-ID: <c49f246c-f599-bb32-0587-43260ca6a764@suse.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
 <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
 <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
 <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
 <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
 <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
 <6863b12b-9095-aaf3-6140-80968e0071e2@users.sourceforge.net>
 <639f00cc-5041-7ec0-b7f2-6ddb81129d15@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <639f00cc-5041-7ec0-b7f2-6ddb81129d15@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On 20/07/16 13:34, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 20 Jul 2016 13:03:16 +0200
>=20
> * Adjust jump targets according to the Linux coding style convention.
>=20
> * A bit of refactoring for the control flow
>=20
> Suggested-by: J=FCrgen Gro=DF <jgross@suse.com>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
