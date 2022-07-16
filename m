Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA462C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 10:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiGPKLV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 06:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGPKLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 06:11:21 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7E71D0CA
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 03:11:18 -0700 (PDT)
Received: from localhost ([82.165.81.187]) by mrelayeu.kundenserver.de
 (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis) id
 1N7Qp1-1nTnxY1qc1-017oqE for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022
 12:11:17 +0200
To:     linux-scsi@vger.kernel.org
Subject: =?utf-8?B?QmVudXR6ZXItS29udG9pbmZvcm1hdGlvbmVuIGbDvHIg0JQ=?=  =?utf-8?B?0L7QsdGA0YvQuSDQtNC10L3RjCEg0J3QsNC/0L7QvNC40L3QsNC10Lwg0L4g?=  =?utf-8?B?0JLQsNGI0LXQvCDQstGL0LjQs9GA0YvRiNC90L7QvCDQsdC40LvQtdGC0LUg?=  =?utf-8?B?0JPQvtGB0JvQvtGC0L4hINCf0L7Qu9GD0YfQuNGC0LUg0LLRi9C40LPRgNGL?=  =?utf-8?B?0Yg6IGh0dHBzOi8vdGlueXVybC5jb20vMmRhenh0cHYgYg==?=  =?utf-8?B?ZWkgVW50ZXJuZWhtZW5zLVdlYnNpdGU=?=
Date:   Sat, 16 Jul 2022 12:11:17 +0200
From:   Unternehmens-Website <braukhoff@gmx.de>
Message-ID: <84646098662c2896dc71bee5d0e56375@braukhoff.eu>
X-Mailer: PHPMailer 5.2.14 (https://github.com/PHPMailer/PHPMailer)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VjHmxtEJCejiUYy51dlU/5heU4ga2gaCK5Z4/hIvrlpZOXWxNAT
 C3jubXU/hCZzPQXo11VLskcs+DL2DEZ2TQkDC9qbnvHKzFOcxlOueTsVlOUUZlkmwiu3noa
 dq5puz1cSd3ZTI+A0fHT/6E7kF/A5QzpA5VTxH52zfixOEnLazMVy5bKkjoCUOL0IA3THyx
 /PmRe5TSWHnKr7A0n7p7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8OQS7rfgz+g=:xs6KzWjRlMnXtwAna0E+ES
 z6c3ETWECYwogaZpr9tJ0xMf8o0xyEn6F3RuhUjdNkNKpxaUuF3uoMY39UXPSxe4UAGR0Ec5R
 /cEImEFbFGI4snDTptNeiVSLa9KxCATXARTY2QFtv/NTkhBDxPN7N3uJ1iSaMfS49X5JjhEh0
 U7Q9WIybs5pRZPES6/G4AoXsNc5jkYbC2KQaXd/X3foem1mlo0D4CRfAXI8w8XGn+rtBNqQ0I
 SD+V/uhUOzUGdaJSmvnjbvTgB5xt2cSNFfafGqpi7BoGKrhHGqxGtuLaF7T8yQIQQBna5HwoL
 mROfKfoSgzJQo1psXGnTwEa9niEPaiRC+4mwv2LpMOc2DQqgl+zdsVabygipSbmRTtIZrLW/M
 lT1l4bVuKpLSc1NFpqwcPbt/dOl3tAoafrFkX0XmX9zZaF4kLXODwnkZCKu3n/BQ7TupE57zk
 pht9vkdzuBvlciQixcgTmaYmmyHuFjV/KagGBX38zW5zIHXtmLd72DsGS8FA/o+dlJH7H0kTu
 EbzdTbVkKuZiKZbiXFkvJ90iGzeB+BHhTEOc2jL74sXclPGmMLYzzL37+m4fXGNLuwWkKsp87
 ncIKEhuIGdco2LMgLKatgkeMalIP0wSUjZtSNK1Jn4VC/Fsebbz74i9QbmSN39M18WHiHw/ye
 JWp5eAmnU/aR2UGPdYYQ+4YuvSmVvF89NENkUd10i9FGlkOfHwvsIGJWrweF29v38ZPGtLvWQ
 EMJvCdo8yzLJ5TTCUQue5jZwiNpO7Y+BIbQTqh55+VV06Xw9+MMvhLcPp0U=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hallo Добрый день! Напоминаем о Вашем выигрышном билете ГосЛото! Получите выигрыш: https://tinyurl.com/2dazxtpv,

vielen Dank für die Registrierung bei Unternehmens-Website. Das Benutzerkonto wurde angelegt und muss zur Verwendung noch verifiziert werden.
Um dieses zu tun, genügt ein Klick auf den folgenden Link oder der Link kann auch aus dieser Nachricht kopiert und in den Webbrowser eingefügt werden:
http://braukhoff.eu/index.php/component/users/?task=registration.activate&token=b5c85e698e913cf72818ad36d980527b

Nach der Verifizierung wird der Administrator über die ausstehende Aktivierung des Benutzerkontos informiert. Sobald das Benutzerkonto aktiviert wurde wird eine Bestätigungsmail verschickt.
Nach der Aktivierung ist eine Anmeldung bei http://braukhoff.eu/ mit dem folgenden Benutzernamen und Passwort möglich:

Benutzername: franacoschtig1973
Passwort: V8NTqm4nad

