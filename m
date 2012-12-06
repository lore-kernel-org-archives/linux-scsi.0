From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] drivers/target/sbp/ : set tport->tpg to NULL when
 clean up for failure.
Date: Thu, 06 Dec 2012 16:40:34 +0800
Message-ID: <50C05A02.6080401@asianux.com>
References: <50C01E16.5080303@asianux.com> <50C058A4.7030403@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:30185 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2LFIjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 03:39:42 -0500
In-Reply-To: <50C058A4.7030403@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net

=D3=DA 2012=C4=EA12=D4=C206=C8=D5 16:34, Chris Boot =D0=B4=B5=C0:
> On 06/12/12 04:24, Chen Gang wrote:
>> Hello Maintainers:=20
>>
>> in drivers/target/sbp/sbp_target.c:
>>
>>    tport->tpg must be NULL before process it in function sbp_make_tp=
g. (line 2185..2188)
>>    tport->tpg assigned a ptr (line 2198)
>>    if processing failed, not set tport->tpg =3D NULL (line 2208..221=
2, 2217..2221)
>>
>>    we have done: when free tport->tpg, set it to NULL (line 2233..22=
34)
>>
>>    is it valuable to let tport->tpg =3D NULL, when clean up for fail=
ure ?
>>
> <snip>
>=20
> Yes, that's a good catch. The way it is now, if we fail to set up the
> TPG, the port will be left in an inconsistent state. I'll prepare a
> patch ASAP unless you'd rather do it yourself.
>=20
> Thanks,
> Chris
>=20

  please help do it (better to mark me as Reported-by in your patch).

  thanks.

  :-)


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
