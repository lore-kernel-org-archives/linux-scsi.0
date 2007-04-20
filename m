From: =?iso-8859-1?q?Ren=E9_Rebe?= <rene@exactcode.de>
Subject: Re: InitIO SCSI: Volunteers required
Date: Fri, 20 Apr 2007 19:23:16 +0200
Message-ID: <200704201923.16996.rene@exactcode.de>
References: <20070420103849.7358f1f1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx02.qsc.de ([213.148.130.14]:34803 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767165AbXDTRr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 13:47:58 -0400
In-Reply-To: <20070420103849.7358f1f1@the-village.bc.nu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday 20 April 2007 11:38:49 Alan Cox wrote:
> I'm looking for some testers for a revamp of the initio driver. No re=
al
> code changes other than to hopefully stop it exploding on load on 64b=
it,
> but a major reorganisation, commenting and "de-windowsification" so t=
he
> code is actually readable and I can do the pci_find_device to
> pci_get_device transitions.

I once had  such a card flying around, feel free to attach it to me
and I can see if I find the card in some box over the weekend :-)

Yours,

--=20
  Ren=E9 Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  Gesch=E4ftsf=FChrer: Susanne Klaus, Ren=E9 Rebe
  Sitz: Berlin, Amtsgericht Charlottenburg HRB 105 123 B
  USt-IdNr.: DE251602478
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
