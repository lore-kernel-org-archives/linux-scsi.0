From: Grant Grundler <grundler@google.com>
Subject: Re: Looking for LSI contact for mptsas driver
Date: Tue, 15 Dec 2009 17:32:02 -0800
Message-ID: <da824cf30912151732t20d7c73tf220a6941c91a413@mail.gmail.com>
References: <02B16CD25461354295D12236BDA8C0E1707ECBF208@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:42432 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422AbZLPBcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 20:32:09 -0500
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out.google.com with ESMTP id nBG1W6AG003047
	for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2009 01:32:06 GMT
Received: from ewy7 (ewy7.prod.google.com [10.241.103.7])
	by spaceape13.eur.corp.google.com with ESMTP id nBG1W3aI023272
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2009 17:32:04 -0800
Received: by ewy7 with SMTP id 7so522421ewy.38
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2009 17:32:03 -0800 (PST)
In-Reply-To: <02B16CD25461354295D12236BDA8C0E1707ECBF208@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill.Hooper@emulex.com
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 15, 2009 at 5:05 PM,  <Bill.Hooper@emulex.com> wrote:
> I am looking for a LSI contact for the mptsas driver. I have encounte=
red some issues and would like to talk to someone about them.

1)  fgrep lsi.com MAINTAINERS
M:      Eric Moore <Eric.Moore@lsi.com>
M:      support@lsi.com
L:      DL-MPTFusionLinux@lsi.com
M:      Neela Syam Kolli <megaraidlinux@lsi.com>

2) Look for Signed-off-by lines in git source tree:
    http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;=
a=3Dshortlog
then select a mpt fusion driver patch:
    http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;=
a=3Dcommit;h=3De46b63b37c3296f0aca92d8b62bbf130f2bec7dd

cheers,
grant

>
> Thanks,
>
> Bill Hooper
> Emulex--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
