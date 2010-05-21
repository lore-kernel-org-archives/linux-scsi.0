From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 16010] New: Mptlinux update problem but need
Date: Fri, 21 May 2010 09:04:58 -0500
Message-ID: <1274450698.2764.5.camel@mulgrave.site>
References: <bug-16010-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0EUOFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2010 10:05:03 -0400
In-Reply-To: <bug-16010-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-05-20 at 07:24 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> For Omsa 6.0.1 is need mptlinux version more than 3.04 present in ker=
nel
> I have download 4.22 from lsi site and try build update driver with d=
kms, i
> have already do same on 2.6.26 past without problem but with 2.6.32 g=
ive this
> compilation error:
>=20
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c: In function
> =E2=80=98mptsas_smp_handler=E2=80=99:
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2757: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2758: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2775: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2805: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2808: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2821: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2823: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2854: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2855: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2864: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> /var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.c:2867: error: =E2=80=98=
struct request=E2=80=99
> has no member named =E2=80=98data_len=E2=80=99
> make[3]: *** [/var/lib/dkms/mptlinux/4.22.00.00/build/mptsas.o] Error=
 1
> make[2]: *** [_module_/var/lib/dkms/mptlinux/4.22.00.00/build] Error =
2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2=20
>=20
> Is possible update mptlinux on new kernel version please?

bugzilla.kernel.org is for actual bugs within the linux kernel, not for
problems with out of tree drivers.  The issue you're trying to report
needs to be fixed by LSI.  While it's not impossible they would notice
this request on the scsi mailing list, you're much more likely to get
their attention by requesting support directly from them.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
