Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46963C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 16:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjGZQUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjGZQUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 12:20:49 -0400
Received: from mailsenadoer.gob.ar (mailsenadoer.gob.ar [190.183.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15671BDA
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 09:20:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mailsenadoer.gob.ar (Postfix) with ESMTP id E85A7184786D
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 14:20:18 -0300 (-03)
Received: from mailsenadoer.gob.ar ([127.0.0.1])
        by localhost (mailsenadoer.gob.ar [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id O0dvwawl6E8l for <linux-scsi@vger.kernel.org>;
        Mon, 24 Jul 2023 14:20:18 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by mailsenadoer.gob.ar (Postfix) with ESMTP id 814771A43490
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 12:03:31 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 mailsenadoer.gob.ar 814771A43490
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailsenadoer.gob.ar;
        s=dkimmailsenadoer; t=1690038211;
        bh=Aor/WLwl4h5zbhGzya8ajVmHiT+79UPpoXAPFDddDh4=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=izc7509Si/vIGj67XjaJEcGOx+BxCrTseIBX4q79gvYKRDwX6tIcr7zE0bpyXzV8O
         iDzQmaXVMerCzL091qkYw20E4uyLUY1L96bP4B0X5mHQimteEddMYAbSsHlhCWX7Ko
         kF+oVcJh2ZJ9UDi3IMERpVxhQnSuDOFr83RMUteIZEWFFy+uYa6hzg3M4KG2l/tQ5g
         OhXRTaRx0oQJQcL5V0zb+ju+AtAoQ5FzPeCoivJBEWBgeFWSLh51Bqs2rg60qxyoXu
         T45eOGn8CWOmeV6KUB6aHTlHBtz25ogef9a8xIbMK1mW/QZiZUy6plpbTsjbG96lTA
         JGBwLvdkUyWaA==
X-Virus-Scanned: amavisd-new at mailsenadoer.gob.ar
Received: from mailsenadoer.gob.ar ([127.0.0.1])
        by localhost (mailsenadoer.gob.ar [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZE_g4qwVYV_e for <linux-scsi@vger.kernel.org>;
        Sat, 22 Jul 2023 12:03:31 -0300 (-03)
Received: from [192.168.0.166] (unknown [105.8.7.246])
        by mailsenadoer.gob.ar (Postfix) with ESMTPSA id 61AD017050D9
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 13:57:07 -0300 (-03)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?b?RHVsZcW+aXTDoSB6cHLDoXZhOyDigqwgMiwwMDAsMDAwJzAwIEVVUg==?=
To:     linux-scsi@vger.kernel.org
From:   "Pan Richard Wahl" <santacruz@mailsenadoer.gob.ar>
Date:   Fri, 21 Jul 2023 09:57:03 -0700
Reply-To: info@wahlfoundation.org
Message-Id: <20230721165709.61AD017050D9@mailsenadoer.gob.ar>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drah=C3=BD pr=C3=ADteli,

Jsem pan Richard Wahl, mega v=C3=ADtez 533 milionu $ v jackpotu Mega Millio=
ns. Daruji 5 n=C3=A1hodne vybran=C3=BDm lidem. Pokud obdr=C5=BE=C3=ADte ten=
to e-mail, byl v=C3=A1=C5=A1 e-mail vybr=C3=A1n po roztocen=C3=AD koule. Ve=
t=C5=A1inu sv=C3=A9ho majetku jsem rozdal rade charitativn=C3=ADch organiza=
c=C3=AD a organizac=C3=AD. Dobrovolne jsem se rozhodl venovat v=C3=A1m c=C3=
=A1stku =E2=82=AC 2,000,000'00 EUR jako jednomu z 5 vybran=C3=BDch, abych s=
i overil sv=C3=A9 v=C3=BDhry prostrednictv=C3=ADm n=C3=AD=C5=BEe uveden=C3=
=A9 str=C3=A1nky YouTube.

VID=C3=8DTE ME ZDE https://www.youtube.com/watch?v=3Dtne02ExNDrw

TOTO JE V=C3=81=C5=A0 DAROVAC=C3=8D K=C3=93D: [DFDW43034RW2023]

Odpovezte na tento e-mail a uvedte k=C3=B3d daru: info@wahlfoundation.org

Douf=C3=A1m, =C5=BEe v=C3=A1m a va=C5=A1=C3=AD rodine udel=C3=A1m radost.

Pozdravy,
Pan Richard Wahl
