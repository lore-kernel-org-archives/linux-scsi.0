Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2B3C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A6E61285
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhDSPBd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 11:01:33 -0400
Received: from mail-2.au.de ([178.15.128.195]:44755 "EHLO mail-2.au.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239230AbhDSPBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Apr 2021 11:01:33 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2021 11:01:32 EDT
Received: from svAUHSex2016.au.de (10.81.30.19) by svAUHSex2016-2.au.de
 (10.81.30.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 19 Apr
 2021 16:46:00 +0200
Received: from svAUHSex2016.au.de ([fe80::990a:9444:b310:e679]) by
 svAUHSex2016.au.de ([fe80::990a:9444:b310:e679%6]) with mapi id
 15.01.2176.009; Mon, 19 Apr 2021 16:46:00 +0200
From:   =?iso-8859-1?Q?Michael_Dr=FCing?= <michael.drueing@au.de>
To:     "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
CC:     "'jinpu.wang@cloud.ionos.com'" <jinpu.wang@cloud.ionos.com>
Subject: Linux pm8001 driver / PMC-Sierra PM8072 card
Thread-Topic: Linux pm8001 driver / PMC-Sierra PM8072 card
Thread-Index: Adc1Kq9AdIc2/kOpRX2OqV2qsTcimg==
Date:   Mon, 19 Apr 2021 14:45:59 +0000
Message-ID: <de4a733fe583543146bc89620a11d000dcd723ce@localhost>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.50.140]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I have a PMC-Sierra 8072 card that the current pm80xx driver does not like. The card uses the PCI vendor ID of PMC-Sierra (11f8) combined with 8072 as device ID, while the pm80xx driver only seems to support the 8072 device when coupled with the ATTO vendor ID.

When I try to force the driver to detect the card (by sending "11f8 8072" to the new_id node in procfs), all I get is a panic in the module.

I have one of these cards that I would be willing to ship to someone who volunteers to add support for it to the driver. Please contact me directly if interested.

Best regards,
-Michael
Advanced UniByte GmbH
Hauptsitz Metzingen:    Paul-Lechler-Straße 8 | 72555 Metzingen
        HRB 352782 | Amtsgericht Stuttgart | Geschäftsführer: Sandro Walker
        Telefon: +49 7123 9542 - 0 | Fax: +49 7123 9542 - 3 - 100 | info@au.de<mailto:info@au.de> | www.au.de<http://www.au.de>
Niederlassung Freiburg: Kronenstraße 34 | 79211 Denzlingen
Niederlassung München:  Industriestraße 31 | 82194 Gröbenzell
Niederlassung Leverkusen:       Platz der Innovationen | Marie-Curie-Straße 16 | 51377 Leverkusen
Diese E-Mail ist nur für den Empfänger bestimmt und kann vertrauliche oder rechtlich geschützte Informationen enthalten,
deren Kopieren, Weitergabe an Dritte oder sonstige Verwendung untersagt ist. Wenn Sie nicht der richtige Empfänger sind,
unterrichten Sie uns bitte umgehend telefonisch oder per E-Mail und löschen Sie diese E-Mail. Vielen Dank!
