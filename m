From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Subject: Re: puzzling scsi return code 20000
Date: Thu, 29 Jul 2004 18:11:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4109219F.1040007@univ-nantes.fr>
References: <40E9448F.1090700@univ-nantes.fr> <20040706184626.GA30970@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from feyd.cri.univ-nantes.fr ([193.52.125.55]:14769 "EHLO
	smtp.cri.univ-nantes.fr") by vger.kernel.org with ESMTP
	id S268518AbUG2QLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2004 12:11:10 -0400
In-Reply-To: <20040706184626.GA30970@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org

Andrew Vasquez wrote:

>On Mon, 05 Jul 2004, Yann Dupont wrote:
>
> =20
>
>>hello. I have some problems with a SAN here. Don't know if the proble=
ms=20
>>lies in scsi code/driver or other thing...
>>   =20
>>
Ok, final words .
My problem is solved. In fact my problemS ARE solved:

Thanks a lot to andrew vasquez who took time to explain me lots of=20
things, and the invaluable tips he gave me to put
the driver in debug mode. It has explained lots, lots of things.

So . In fact, I had 2 distincts problems.
1 FC HBA wich was dying (lots of underrun status when the driver is in=20
debug mode)
1 SFP (Gbic) which was making problems on the 2nd channel of a Raid.

That's why I was seeing SCSI errors on 2 hosts. In fact , the problems=20
were not related at all :-(. Took me time
to figure that !


--=20
Yann Dupont, Cri de l'universit=E9 de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
