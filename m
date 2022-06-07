Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC59C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 16:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbiFGQUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345046AbiFGQU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 12:20:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49AF101712
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 09:20:27 -0700 (PDT)
Date:   Tue, 7 Jun 2022 18:20:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654618825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9waIUo2weNXhnQCuvQRDnDISX8b6nBt1JtdasxDEus=;
        b=jtpFAb+JkMsxQ/hjh4dsksb2yfWeplYfa92DrMBWycNsFjsRonNdrDZVPVAt2QmIckZMUc
        07akcGtq90/P7uKIEIqKjzzvJYHDGX1f+QxTfcum2bEUPi/2Rrf+sEDZRbDQWr6X6Fg9kv
        jhEpkizQ2t8rlCIdjPNAaEnTWz8zA7+MGkVX5l/O+5QRpaJIWU2lD6V9v1JZp3XWu3FUZB
        DG2fESDhTjOMuzpJQdoRpLEPMsaWjPdq0CxjwGzdhgVOiVTkLRtgDQbtJGSsQ+Zz6hSbW4
        P4cEAFXNeHx177HSOAaTtuFUOu/yty426jZz94oSIBrYovMTjvPpw7Q8ulIwaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654618825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9waIUo2weNXhnQCuvQRDnDISX8b6nBt1JtdasxDEus=;
        b=U+KEkZwoAl6WD5tMVFqnsMf4l6FanZIiUI0r4YG/FdQBhZ7HBkF1Vn3zgulhvMI/GO5Wqw
        y5g4ziJn3Qj/3nBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 00/10] scsi: Replace tasklets as BH
Message-ID: <Yp96yKc0zhXbN3cp@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <YphtdGbu2rhx4RaQ@linutronix.de>
 <20220607155918.i5f7pkqadeiuaqpn@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220607155918.i5f7pkqadeiuaqpn@offworld>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-06-07 08:59:18 [-0700], Davidlohr Bueso wrote:
>=20
> Thanks for the careful reviewing and feedback. I'll address
> them in a v2 as soon as I get a chance.

I didn't get through the whole series as of now but I guess you can
apply what I said so far also to the remaining part ;)

The series actually reminding me that I have a be2iscsi patch hiding
somewhere asking to get reposted=E2=80=A6

> Thanks,
> Davidlohr

Sebastian
