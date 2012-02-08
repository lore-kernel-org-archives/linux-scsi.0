From: Christian Hoff <christian.hoff@de.ibm.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Wed, 8 Feb 2012 14:37:16 +0100
Message-ID: <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:46262 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2BHNhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 08:37:31 -0500
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <christian.hoff@de.ibm.com>;
	Wed, 8 Feb 2012 13:37:29 -0000
In-Reply-To: <4F313526.2050907@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: BORNTRAE@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au

Paolo Bonzini wrote:
> Christian Hoff wrote:
> > Instead the format has some disadvantages:
> > - It uses up 8 bytes where 3 bytes would be sufficient in order to=20
store
> > both the target ID and LUN number information
> > - The format limits us to 255 target IDs. I agree that the LUN limi=
t=20
is
> > probably more a theoretical and not a practical one, but 255 target=
=20
IDs
> > could become a limitation in the future.
>
> It also provides better upwards-compatibility in case the limitations=
=20
> are actually hit.  If I had used "uint8_t target; uint16_t lun;" an=20
> extension would require a feature bit and a new struct.  With 8-bytes=
,=20
> you can just expand the definition.  That pretty much sums it up.

Ok, fair enough. This addresses my question.

Again, I have already done much testing with virtio-scsi and can confir=
m=20
that the code is working flawlessly. In my opinion, virtio-scsi is a=20
worthwhile addition to virtio-block and should be considered for inclus=
ion=20
into mainline kernel code.

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
