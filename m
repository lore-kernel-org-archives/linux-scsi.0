Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_NAME_MR_MRS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE3ECA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 05:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830F520830
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 05:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mcontreras.gob.mx header.i=@mcontreras.gob.mx header.b="MuP6JsG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJUFRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 01:17:43 -0400
Received: from customer-187-141-58-171-sta.uninet-ide.com.mx ([187.141.58.171]:35168
        "EHLO correo.mcontreras.gob.mx" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbfJUFRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 01:17:43 -0400
X-Greylist: delayed 10228 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 01:17:42 EDT
Received: from localhost (localhost [127.0.0.1])
        by correo.mcontreras.gob.mx (Postfix) with ESMTP id 7865AEE7D4F7
        for <linux-scsi@vger.kernel.org>; Sun, 20 Oct 2019 17:58:06 -0500 (CDT)
Received: from correo.mcontreras.gob.mx ([127.0.0.1])
        by localhost (correo.mcontreras.gob.mx [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RLD3Yy6UjGaP for <linux-scsi@vger.kernel.org>;
        Sun, 20 Oct 2019 17:58:06 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by correo.mcontreras.gob.mx (Postfix) with ESMTP id F1BFEC7EA2C6
        for <linux-scsi@vger.kernel.org>; Sun, 20 Oct 2019 16:39:33 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 correo.mcontreras.gob.mx F1BFEC7EA2C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mcontreras.gob.mx;
        s=53A92184-CD91-11E8-86DF-F45FB6B066AC; t=1571607575;
        bh=Rqp1tqcd8K/qNgrJx+rtaGPrHlODB2s2MX0PKJm7Ymc=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=MuP6JsG+dkUG1i2adLWg56NINQddWmeBGhGMb0Tf6C/wg2TewLWAJ1jrxiK0rew6D
         J/j7KxiuRRLcIqFTLH5t8P6EZQJIdWRYAXfIyIIiloN82dZu9lonSl+q+bCvEa3gcb
         TwGngzPVmm7sI95HwC7ZMaF2IQti37eCoNgVx76+4oVkooKRaD7XEImccT7ABYKTr1
         NRbdOBD7i0hnULZ8ehBycRLEubQdbU8f1/JHl3t/2t2dfgu5WUwFzqBxUv0Yyjp9ys
         3EoC2bi+h97x86oxecdKLbNQnQRrqXTN6VDuhQlM2iUEDG5zNyiSD0650BiXiT3HDk
         b7Y0Gm9m5s/UA==
X-Amavis-Modified: Mail body modified (using disclaimer) -
        correo.mcontreras.gob.mx
X-Virus-Scanned: amavisd-new at mcontreras.gob.mx
Received: from correo.mcontreras.gob.mx ([127.0.0.1])
        by localhost (correo.mcontreras.gob.mx [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yv0Kde13Nu5X for <linux-scsi@vger.kernel.org>;
        Sun, 20 Oct 2019 16:39:33 -0500 (CDT)
Received: from [192.168.0.111] (unknown [92.99.96.15])
        by correo.mcontreras.gob.mx (Postfix) with ESMTPSA id 57148B19566F
        for <linux-scsi@vger.kernel.org>; Sun, 20 Oct 2019 16:22:18 -0500 (CDT)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Proposal
To:     linux-scsi@vger.kernel.org
From:   "Mr. Maheed " <m.rosas@mcontreras.gob.mx>
Date:   Sun, 20 Oct 2019 14:21:04 -0700
Reply-To: asadmaheed9@gmail.com
Message-Id: <20191020212219.57148B19566F@correo.mcontreras.gob.mx>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I have a special discussion to discuss with you please get back to me.
Sincerely,
Mr. Maheed Asad
Alcaldia La Magdalena Contreras Coordinacion

