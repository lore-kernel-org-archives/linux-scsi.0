From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16010] Mptlinux update problem but need
Date: Fri, 21 May 2010 14:05:45 GMT
Message-ID: <201005211405.o4LE5jaZ013064@demeter.kernel.org>
References: <bug-16010-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41512 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0EUOFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2010 10:05:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4LE5j2v013065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 May 2010 14:05:45 GMT
In-Reply-To: <bug-16010-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D16010





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org> =
 2010-05-21 14:05:40 ---
Reply-To: James.Bottomley@suse.de

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

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
