From: Justin Rosander <myrddinemrys@neo.rr.com>
Subject: Re: PROBLEM: LSIFC909 mpt card fails to recognize devices
Date: Sun, 07 Jan 2007 13:07:07 -0500
Message-ID: <1168193227.4458.2.camel@localhost>
References: <1167955606.5133.13.camel@localhost>
	 <20070104165922.137c6df9.akpm@osdl.org>  <20070105035526.GA14185@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01.ohiordc.rr.com ([65.24.5.135]:56895 "EHLO
	ms-smtp-01.ohiordc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbXAGSHR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jan 2007 13:07:17 -0500
In-Reply-To: <20070105035526.GA14185@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Eric,
I tried recompiling the kernel per your instructions, but I got a
failure here:
          CC [M]  drivers/message/fusion/mptbase.o
        drivers/message/fusion/mptbase.c: In function =E2=80=98mpt_resu=
me=E2=80=99:
        drivers/message/fusion/mptbase.c:1526: warning: ignoring return=
 value of =E2=80=98pci_enable_device=E2=80=99, declared with attribute =
warn_unused_result
          CC [M]  drivers/message/fusion/mptscsih.o
        drivers/message/fusion/mptscsih.c: In function =E2=80=98mptscsi=
h_initTarget=E2=80=99:
        drivers/message/fusion/mptscsih.c:2691: error: =E2=80=98lun=E2=80=
=99 undeclared (first use in this function)
        drivers/message/fusion/mptscsih.c:2691: error: (Each undeclared=
 identifier is reported only once
        drivers/message/fusion/mptscsih.c:2691: error: for each functio=
n it appears in.)
        make[4]: *** [drivers/message/fusion/mptscsih.o] Error 1
        make[3]: *** [drivers/message/fusion] Error 2
        make[2]: *** [drivers/message] Error 2
        make[1]: *** [drivers] Error 2

Did I do something wrong?
Regards,
Justin

On Thu, 2007-01-04 at 20:55 -0700, Eric Moore wrote:
> On Thu, Jan 04, 2007 at 04:59:22PM -0800, Andrew Morton wrote:
> > On Thu, 04 Jan 2007 19:06:46 -0500
> > Justin Rosander <myrddinemrys@neo.rr.com> wrote:
> >=20
> > > Please forward this to the appropriate maintainer.  Thank you.
> > >=20
> > > [1.] One line summary of the problem:    My fibre channel drives =
fail to
> > > be recognized by my LSIFC909 card.=20
> >=20
> > Please send the output of `lspci -vn'
> > -
>=20
> Recompile the driver with MPT_DEBUG_INIT enabled in the driver Makefi=
le,
> and repost the output.
>=20
> Eric Moore

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
