Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08812C001DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 16:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjGZQSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 12:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjGZQSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 12:18:23 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9421BE8;
        Wed, 26 Jul 2023 09:18:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 87495C0004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690388299; bh=P1tYjsYpvaWM0Kp4oS8LddO1u5/c7/5r3F2xBGS+4bQ=;
        h=MIME-Version:Content-Type:Date:Message-ID:Subject:To:From:From;
        b=cX4v3iWXxygpb2w5QhgdSNX7OavK1/RsS6AtQIleAgIDfmBBgxk6WbDNH4jThSStC
         RKSzG3eQS4XZ8ZsI3OPOORDANQYbBBZEOjGZq4mRGw8S3DZap0XOB54o5qmeuzy43M
         GPkRkFLLNbyM3J7qxz1KBuOP/MZuEeJ2B36+ugKuH6IJvQ5fRlfpcj1zxf2tundvK+
         AgN3TQErZ58Cup9BAGy4EIdXGRHWqv9gacXTYZTsExA7tTHBPdvOpZj8RL9GYtNw2F
         jifHpa2G595PFzLdTW767VrkbzOwRnIu7Rr+M2ZwvWPxDw+hHmmWBnaOsbYgfUkgr2
         bKmmWuTocKMEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690388299; bh=P1tYjsYpvaWM0Kp4oS8LddO1u5/c7/5r3F2xBGS+4bQ=;
        h=MIME-Version:Content-Type:Date:Message-ID:Subject:To:From:From;
        b=LHSDrnzLj91Dv+fy2E8WZ1lF7YtJce1uMWqIpvhsNThC3cqq4FtpLNWGMz6aYckop
         6k920BlBGQHQ0tefM/XLmMPknqmw2lrcdAHgKwJfQ9hYCwx5i1UVSBxml0EiGu20AJ
         fG/DMhIKgrf2cEiFHGcD2rpngk6nswFglmo2qHtIXWlFx1L+IVHivreXf0yCEF7jjd
         Sq04AZccHVoQZaA6yxx9NiizLmh0pGVYP47FoRrp1hDB9fuldmlqSswwjy6nplyVZF
         Yvhbvdasj0RBQBTFMcFFDFBlrSmpSLfihsvQfk5hvGf+kG5PyEXnU/U6puBS7MNY8M
         JDqWHFzHPVifA==
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 26 Jul 2023 19:18:14 +0300
Message-ID: <CUC8N20VEZVD.2FX0OUJJLSI68@pogg>
Subject: Re: [DMARC Error]Re: [RFC PATCH 2/3] target: core: apply the new
 wrapper to spc
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>,
        <martin.petersen@oracle.com>, <michael.christie@oracle.com>
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
X-Mailer: aerc 0.15.2.r104.g81f5237
References: <20230726115509.357-1-a.kovaleva@yadro.com>
 <20230726115509.357-3-a.kovaleva@yadro.com>
 <f3a58522-3957-bd70-df87-9df7e4547195@acm.org>
In-Reply-To: <f3a58522-3957-bd70-df87-9df7e4547195@acm.org>
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed Jul 26, 2023 at 6:15 PM MSK, Bart Van Assche wrote:
> =C2=AB=D0=92=D0=BD=D0=B8=D0=BC=D0=B0=D0=BD=D0=B8=D0=B5! =D0=94=D0=B0=D0=
=BD=D0=BD=D0=BE=D0=B5 =D0=BF=D0=B8=D1=81=D1=8C=D0=BC=D0=BE =D0=BE=D1=82 =D0=
=B2=D0=BD=D0=B5=D1=88=D0=BD=D0=B5=D0=B3=D0=BE =D0=B0=D0=B4=D1=80=D0=B5=D1=
=81=D0=B0=D1=82=D0=B0!=C2=BB
>
> On 7/26/23 04:55, Anastasia Kovaleva wrote:
> > +#define TARGET_PREFIX "core"
>
> I'm not sure this is a good choice for a logging prefix since this name
> does not make it clear that log lines come from the SCSI target core.
> How about "scsi_tgt" as prefix? "stgt" is probably not a good choice
> since this is the former name of a user-space SCSI target project
> (https://github.com/fujita/tgt).
>
> Bart.

I think scsit is a good choice, like nvmet we already have.
