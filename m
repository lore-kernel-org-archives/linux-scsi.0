Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679D1CD548A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 07:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjISHhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 03:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjISHhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 03:37:34 -0400
X-Greylist: delayed 423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Sep 2023 00:37:29 PDT
Received: from mail.leeswilly.pl (mail.leeswilly.pl [89.116.26.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EC910F
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 00:37:28 -0700 (PDT)
Received: by mail.leeswilly.pl (Postfix, from userid 1001)
        id 327F7761146; Tue, 19 Sep 2023 09:30:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leeswilly.pl; s=mail;
        t=1695108621; bh=qCQG4c3C0tvkuSSy6okg6Td4OKi9mrw7rI9pE9SwJ9g=;
        h=Date:From:To:Subject:From;
        b=aSbj/I5asTZMvPZj8BafnlRzCvwlMcpfZhZIBE9/cSE+97ZEIRsT0afekxCgJWxWO
         YlaHxcj3JKlp6OOPw4YsF5JcT7pE/tXKqr8SO/g7jU1yTcXOYxatA+bGYL6xFObWW3
         ofXboVQIpc0wBYBK2IZCyMOSjUd9ZvLPBm+4B2gOCzvh2dpStzz/whIl15+d7CeXu8
         SEIamh3+kj1MmtE3DI3oUj6CqoVvCVRnOVS6rWV+s3dNlVIVWw6b+koCrkjejTm5Zu
         t2rSR3YaQGNAv75EyEWK/nFDyWnC3fhYulIJUNIcHU0UKatv0DZJNYAfNRI49g+MJu
         D1oD7oL9nYK9A==
Received: by mail.leeswilly.pl for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 07:30:18 GMT
Message-ID: <20230919084500-0.1.3z.bb8l.0.z66mj5k559@leeswilly.pl>
Date:   Tue, 19 Sep 2023 07:30:18 GMT
From:   "Jakub Lemczak" <jakub.lemczak@leeswilly.pl>
To:     <linux-scsi@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.leeswilly.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dzie=C5=84 dobry,

Czy interesuje Pa=C5=84stwa rozwi=C4=85zanie umo=C5=BCliwiaj=C4=85ce moni=
torowanie samochod=C3=B3w firmowych oraz optymalizacj=C4=99 koszt=C3=B3w =
ich utrzymania?=20


Pozdrawiam
Jakub Lemczak
