From: Johan Kragsterman <johan.kragsterman@capvert.se>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Sat, 19 May 2007 06:57:12 +0200
Message-ID: <2d19f51c0e0a50bbea21c1a83f21965b@cgw.capvert.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-213.50.125.130.addr.tdcsong.se ([213.50.125.130]:41864
	"EHLO ns1.capvert.ins" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXESEwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 May 2007 00:52:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Johan Kragsterman <johan.kragsterman@capvert.se>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, sandip shete <sandipshete@gmail.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org



Andrew Vasquez <andrew.vasquez@qlogic.com> Skrev:=20
>

On Fri, 18 May 2007, Johan Kragsterman wrote:
>
>> >Most probably, the driver by link sent by Matthew Jacob will be a g=
ood=20
>> >starting point, where you can see examples how to work with the car=
d, so
>
>> >you can add it to the qla2x00t driver. Also you will need a manual =
the=20
>> >firmware interface specification for 2400 series of the cards. It i=
s=20
>> >under NDA, but you maybe lucky to get one from QLogic. Feel free to=
 ask
>
>> >me any SCST or qla2x00t driver related questions.
>> >
>> >> I have adequate experience of programming in the SCSI domain, how=
ever
>i=20
>> >> am not much conversant with the QLA driver code.
>>=20
>> That=B4s a very nice initiativ! Though I believe the most important =
target
>> driver to develope is one for a PCI-Express HBA. I believe QLA24xx
>stands
>> for PCI-X, doesn=B4t it? And the PCI-Express HBA is called QLE-somet=
hing?
>But
>> maybe with this driver we will come closer to a PCI-Express HBA targ=
et
>> driver?
>
>QLogic doesn't formally release target-mode drivers for their ISP
>chips.  Matthew J. has done a great job at providing a community
>available souce-base from which to draw ideas and code from.
>
>Regards,
>Andrew Vasquez
>
>
So, Andrew, do you officially represent Qlogic? If so, your point of vi=
ew
here is interesting, since you seem to consider that: "Matthew J. has d=
one a
great job at providing a community available souce-base from which to d=
raw
ideas and code from".
 In what way is Qlogic interested in helping the community with providi=
ng
open firmware, drivers and tools?

 Rgrds Johan


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
