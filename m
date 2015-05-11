From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v5 3/3] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Mon, 11 May 2015 10:57:28 +0530
Message-ID: <CAOHikRD5dVNDAUQ-tstk0ndkbMoZikGgXuT7N2xxm56yDVtA2Q@mail.gmail.com>
References: <1430853672-6227-1-git-send-email-stripathi@apm.com>
	<1430853672-6227-4-git-send-email-stripathi@apm.com>
	<20150510155454.GD5856@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:33329 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739AbbEKF1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 01:27:30 -0400
Received: by wgic8 with SMTP id c8so90715456wgi.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 May 2015 22:27:28 -0700 (PDT)
In-Reply-To: <20150510155454.GD5856@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

On Sun, May 10, 2015 at 9:24 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, May 06, 2015 at 12:51:12AM +0530, Suman Tripathi wrote:
>> +     switch (version) {
>> +     case XGENE_AHCI_V1:
>> +             hpriv->flags = AHCI_HFLAG_NO_NCQ;
>> +             /*
>> +              * Override the callbacks for storm ERRATA
>> +              */
>> +             xgene_ahci_ops.qc_issue = xgene_ahci_qc_issue;
>> +             xgene_ahci_ops.softreset = xgene_ahci_softreset;
>> +             xgene_ahci_ops.pmp_softreset = xgene_ahci_pmp_softreset;
>
> Let's please create separate ops structs for v1 and v2.

Good idea . Will do that .

>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
