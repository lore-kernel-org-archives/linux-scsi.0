From: Johan Kragsterman <johan.kragsterman@capvert.se>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Fri, 18 May 2007 18:00:28 +0200
Message-ID: <939b36a7f9795b71218bb5b4905e6250@cgw.capvert.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-213.50.125.130.addr.tdcsong.se ([213.50.125.130]:41584
	"EHLO ns1.capvert.ins" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754315AbXERQLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 12:11:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, sandip shete <sandipshete@gmail.com>
Cc: scst-devel@lists.sourceforge.net, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi, all!

>Vladislav Bolkhovitin <vst@vlnb.net> Skrev:=20
>

sandip shete wrote:
>> Hi,
>>=20
>> I wish to develop support for QLA 24xx series. If you already have a=
=20
>> partial implementaion of the same, i would like to take it forward.
>> And if there isn't, i would appreciate if you could give me some=20
>> pointers in that direction.
>
>Most probably, the driver by link sent by Matthew Jacob will be a good=
=20
>starting point, where you can see examples how to work with the card, =
so=20
>you can add it to the qla2x00t driver. Also you will need a manual the=
=20
>firmware interface specification for 2400 series of the cards. It is=20
>under NDA, but you maybe lucky to get one from QLogic. Feel free to as=
k=20
>me any SCST or qla2x00t driver related questions.
>
>> I have adequate experience of programming in the SCSI domain, howeve=
r i=20
>> am not much conversant with the QLA driver code.

That=B4s a very nice initiativ! Though I believe the most important tar=
get
driver to develope is one for a PCI-Express HBA. I believe QLA24xx stan=
ds
for PCI-X, doesn=B4t it? And the PCI-Express HBA is called QLE-somethin=
g? But
maybe with this driver we will come closer to a PCI-Express HBA target
driver?

Rgrds Johan



>>=20
>> Thanks and Regards,
>> Sandip S
>
>----------------------------------------------------------------------=
---
>This SF.net email is sponsored by DB2 Express
>Download DB2 Express C - the FREE version of DB2 express and take
>control of your XML. No limits. Just data. Click to get it now.
>http://sourceforge.net/powerbar/db2/
>_______________________________________________
>Scst-devel mailing list
>Scst-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/scst-devel
>
>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
