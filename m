From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Subject: Re: puzzling scsi return code 20000
Date: Fri, 09 Jul 2004 11:21:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EE6390.1030603@univ-nantes.fr>
References: <40E9448F.1090700@univ-nantes.fr> <20040706184626.GA30970@praka.san.rr.com> <40EBCA9B.90402@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from feyd.cri.univ-nantes.fr ([193.52.125.55]:62923 "EHLO
	smtp.cri.univ-nantes.fr") by vger.kernel.org with ESMTP
	id S264584AbUGIJVW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 05:21:22 -0400
In-Reply-To: <40EBCA9B.90402@univ-nantes.fr>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

Yann Dupont wrote:

>
>
> 2.4.27-rc3 + dm 0.19 + qla 7.00.03 =3D No errors !!!
>

just to say that 2.4.27-rc3 + dm 0.19 + qla 6.06.64 is ok too.

So maybe it's time to suscribe to dm-devel list :) As it really seems=20
the problem was here.

Anyway last thing on this subject - Maybe this list is not the good=20
place for this ,
and I should directly try qlogic support ...

The 7.00.03 qlogic driver seems okay when you read , but when you write=
=20
large chunks of data,
the server hangs unless all data is flushed to disks. Is there someone=20
else seing this behaviour ??

Going back to 6.06.64 fixed the problem.

Any thoughts ?

--=20
Yann Dupont, Cri de l'universit=E9 de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
