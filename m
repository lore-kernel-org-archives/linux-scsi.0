From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Suggestion] drivers/target/sbp/ : set tport->tpg to NULL when
 clean up for failure.
Date: Fri, 14 Dec 2012 16:33:26 -0800
Message-ID: <1355531606.5909.1.camel@haakon2.linux-iscsi.org>
References: <50C01E16.5080303@asianux.com> <50C058A4.7030403@bootc.net>
	 <50C05A02.6080401@asianux.com> <50C54B49.6020000@asianux.com>
	 <50C59704.60303@bootc.net> <50CA962E.9070501@asianux.com>
	 <20121214075728.43b6fb41@stein>  <50CAD3A7.8060308@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50970 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2LOAd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 19:33:28 -0500
In-Reply-To: <50CAD3A7.8060308@asianux.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Chris Boot <bootc@bootc.net>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Fri, 2012-12-14 at 15:22 +0800, Chen Gang wrote:
> =E4=BA=8E 2012=E5=B9=B412=E6=9C=8814=E6=97=A5 14:57, Stefan Richter =E5=
=86=99=E9=81=93:
> > On Dec 14 Chen Gang wrote:
> >> =E4=BA=8E 2012=E5=B9=B412=E6=9C=8810=E6=97=A5 16:02, Chris Boot =E5=
=86=99=E9=81=93:
> >>> On 10/12/12 02:39, Chen Gang wrote:
> >>>> Hello Chris Boot:
> >>>>
> >>>>   need I send the relative patch ?
> >>>
> >>> Hi Chen,
> >>>
> >>> Sorry, life got in the way this weekend. I'll try to get the patc=
h sent
> >>> out today.
> >>>
> >>
> >>   Have you sent ?
> >>
> >>   I am already in linux-scsi@vger.kernel.org mailing list, but it =
seems
> >> not find your patch.
> >=20
> > It was posted at target-devel:
> > http://thread.gmane.org/gmane.linux.scsi.target.devel/3019/focus=3D=
3020
> >=20
>=20
>   oh, thank you very much.
>=20
>   I need join target-devel@vger.kernel.org, I will do.
>=20

=46YI folks, this fix from Chris was included in the [GIT PULL] request
for v3.8-rc1 sent out today.

Thanks!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
