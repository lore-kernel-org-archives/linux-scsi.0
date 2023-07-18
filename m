Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1BDEB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 00:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjGSAaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 20:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGSA37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 20:29:59 -0400
X-Greylist: delayed 1224 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Jul 2023 17:29:58 PDT
Received: from mail.maracanau.ce.gov.br (mail.maracanau.ce.gov.br [187.86.206.254])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E7B139
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 17:29:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.maracanau.ce.gov.br (Postfix) with ESMTP id 04C9FB089AE
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 20:52:24 -0300 (-03)
Received: from mail.maracanau.ce.gov.br ([127.0.0.1])
        by localhost (mail.maracanau.ce.gov.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 4oKZbZFZgE04 for <linux-scsi@vger.kernel.org>;
        Tue, 18 Jul 2023 20:52:23 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by mail.maracanau.ce.gov.br (Postfix) with ESMTP id C210BB08CFB
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 20:52:23 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.maracanau.ce.gov.br C210BB08CFB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maracanau.ce.gov.br;
        s=5B33696C-FA0D-11EC-880A-860953C84890; t=1689724343;
        bh=Aor/WLwl4h5zbhGzya8ajVmHiT+79UPpoXAPFDddDh4=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=a/MtlThZ5xsjPjXaVNtyqL3hzRuHrB48kSLqhplvFKf3wUPijppPEOqYRejy2/IAt
         RjJqOFhWk5/m8pQCl2r/I7+NoEXr3Ssj9WC+J8Jm+szj/uiNheCq/MUrLINpEDYLvC
         N8j9elbD2/QOTnJrt+QGd2ku3Go/xsmuzNy1qZH7trpTC0VrHAVKruV7wWWHGke2xM
         omeUFxCEPc+IWJn4ScQdr+t4JRu+xbEn+1T5SLmqHcMvEeG9P7fT0A/yhMwpE6m5Np
         CzNvSWMIJkj0Z7m42rKFdvW+hV1QdpVijWeb//MVI9nxUkiI/ie9OBOMl9jSFWjmj1
         bqgw1uCHYkPXw==
X-Virus-Scanned: amavisd-new at maracanau.ce.gov.br
Received: from mail.maracanau.ce.gov.br ([127.0.0.1])
        by localhost (mail.maracanau.ce.gov.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9uEwiZerCR25 for <linux-scsi@vger.kernel.org>;
        Tue, 18 Jul 2023 20:52:23 -0300 (-03)
Received: from [192.168.0.166] (unknown [105.8.1.58])
        by mail.maracanau.ce.gov.br (Postfix) with ESMTPSA id DEDA6B0877D
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 20:52:22 -0300 (-03)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?b?RHVsZcW+aXTDoSB6cHLDoXZhOyDigqwgMiwwMDAsMDAwJzAwIEVVUg==?=
To:     linux-scsi@vger.kernel.org
From:   "Pan Richard Wahl" <coordenadoriasdp_camara@maracanau.ce.gov.br>
Date:   Tue, 18 Jul 2023 16:52:16 -0700
Reply-To: info@wahlfoundation.org
Message-Id: <20230718235222.DEDA6B0877D@mail.maracanau.ce.gov.br>
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
