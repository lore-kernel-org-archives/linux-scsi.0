From: "Rafael" <rsantos@unisc.br>
Subject: kernels 2.6.11 and 2.6.12 hanging with ata_piix on poweredge 800
Date: Wed, 06 Jul 2005 10:49:34 -0300
Message-ID: <42CBE16E.4060906@unisc.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sirius.unisc.br ([200.17.83.65]:19150 "EHLO smtp.unisc.br")
	by vger.kernel.org with ESMTP id S262124AbVGFNti convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2005 09:49:38 -0400
Received: from EVS.unisc.br (unknown [192.168.0.62])
	by smtp.unisc.br (Postfix) with ESMTP id 28BBC2844A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2005 10:49:30 -0300 (BRST)
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Cristiano Bonato Both <cboth@unisc.br>, rsantos@unisc.br

Hi,

I recently upgraded the from kernel 2.6.10 to 2.6.11 and 2.6.12 but my=20
poweredge 800 machine hangs when trying to boot after kernel=20
compilation/installation. I was running FC3.

Now I tried FC4 (kernel 2.6.11) and the installation doesnt even starts=
=20
haging when trying to load ata_piix driver. Based on that, I figured th=
e=20
problem maybe with the scsi driver ata_piix. However, I dont know how t=
o=20
confirm that and what am I supposed to do to be able to boot this=20
machine with the new kernels.

Any help with that is greatly appreciated.

Sincerely,
Rafael


___________
Antes de imprimir pense em sua responsabilidade e compromisso com o MEI=
O AMBIENTE!
Setor de Inform=E1tica - UNISC
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
