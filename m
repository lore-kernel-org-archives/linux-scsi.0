From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: 2.6.7 aic7xxx oops
Date: Thu, 1 Jul 2004 17:58:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200407011758.32363.bernd-schubert@web.de>
References: <200407011631.22587.bernd-schubert@web.de> <20040701075325.2adc333d.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:31961 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S265981AbUGAP6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 11:58:41 -0400
In-Reply-To: <20040701075325.2adc333d.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Thursday 01 July 2004 16:53, Randy.Dunlap wrote:
> On Thu, 1 Jul 2004 16:31:21 +0200 Bernd Schubert wrote:
> | Hi,
> |
> | on modprobing the aic7xxx module I just got this oops:
> |
> |
> | Unable to handle kernel paging request at virtual address d08ae620
> |  printing eip:
> | c024e642
> | *pde =3D 0f87b067
> | Oops: 0002 [#1]
> | PREEMPT SMP DEBUG_PAGEALLOC
> | Modules linked in: aic7xxx mga uhci_hcd ohci_hcd md eeprom w83781d
> | i2c_sensor i2c_isa i2c_piix4 i2c_core
> | CPU:    0
> | EIP:    0060:[<c024e642>]    Not tainted
> | EFLAGS: 00010286   (2.6.7-tc1)
>
>                       ~~~~~~~~~
> What kernel (patches applied) is that?
>

Sofar there are no patches applied to this kernel. We usually add -tcX=20
(tc =3D=3D theoretical chemistry ;) ) to our different kernel configura=
tions. So=20
its a vanilla kernel.


Cheers,
	Bernd


--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
