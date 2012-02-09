From: Christian Hoff <christian.hoff@de.ibm.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Thu, 9 Feb 2012 13:18:21 +0100
Message-ID: <OFDF7B0B80.B44589BA-ONC125799F.00410C52-C125799F.00439AD0@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F3390FB.80107@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: BORNTRAE@linux.vnet.ibm.com, James Bottomley <JBottomley@parallels.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au
List-Id: linux-scsi@vger.kernel.org

Paolo Bonzini wrote:
> James, will you include virtio-scsi in 3.4?

The key arguments from my side for inclusion of virtio-scsi are:
- Support for SCSI multipathing, which can optionally be done on the ho=
st=20
operating system.
- We can now use other SCSI(non-block) devices and make them accessible=
 to=20
the guest. For example we were able to virtualize a SCSI FCP tape using=
=20
virtio-scsi. One of the biggest constraints of virtio-block is that it =
is=20
limited to block devices, while virtio-scsi presents you with a more=20
generic solution.

So I consider virtio-scsi to be the cleaner approach to do virtualizati=
on=20
of SCSI commands. This is supported by the fact that virtio-block has a=
=20
maintenance problem and has to change its protocol from time to time to=
=20
support new features introduced by a new version of the SCSI standard.

So please consider including virtio-scsi into the mainline kernel tree.=
=20
This is good and conceptually clean code, and it has proven to work ver=
y=20
well in our internal testing.

Mit freundlichen Gr=FC=DFen / Kind regards

Christian Hoff

Student - Applied Computer Science


Phone:
49-16098976-950
 IBM Deutschland

E-Mail:
christian.hoff@de.ibm.com
 Am Fichtenberg 1


 71083 Herrenberg


 Germany


IBM Deutschland GmbH / Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Martina Koederitz (Vorsitzende), Reinhard Reschke=
,=20
Dieter Scholz, Gregor Pillen, Joachim Heel, Christian Noll
Sitz der Gesellschaft: Ehningen / Registergericht: Amtsgericht Stuttgar=
t,=20
HRB 14562 / WEEE-Reg.-Nr. DE 99369940=20
