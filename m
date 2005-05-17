From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 21:26:36 +0200
Message-ID: <20050517192636.GB9121@gmail.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.196]:27455 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261631AbVEQTbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 15:31:43 -0400
Received: by wproxy.gmail.com with SMTP id 49so148982wri
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 12:31:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116354894.4989.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 17, 2005 at 01:34:53PM -0500, James Bottomley wrote:

> So, to get all of these changes, could you start with vanilla linus
> kernel 2.6.12-rc4 (or tree based on this, but not -mm which already h=
as
> some of the SCSI tree included) and then apply the SCSI patch at
>=20
> http://parisc-linux.org/~jejb/scsi_diffs/scsi-misc-2.6.diff
>=20
> and see if it works?

Well, it don't... I send you a private mail with a picture I take a boo=
t
time.

Thank,
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
