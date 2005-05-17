From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 21:56:50 +0200
Message-ID: <20050517195650.GC9121@gmail.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave> <20050517192636.GB9121@gmail.com> <1116359432.4989.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.201]:60630 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261357AbVEQT4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 15:56:53 -0400
Received: by wproxy.gmail.com with SMTP id 68so3045166wri
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 12:56:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116359432.4989.48.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 17, 2005 at 02:50:31PM -0500, James Bottomley wrote:

> Right, but the problem I think it will fix is the initial inquiry bei=
ng
> sent with the wrong transport parameters.
>=20
> You have a different problem, I think ... it looks like your Toshiba =
DVD
> does somthing strange during Domain Validation ... the question I don=
't
> have an answer to yet, is what.

Oh, sorry, thank you for the patch :-)
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
