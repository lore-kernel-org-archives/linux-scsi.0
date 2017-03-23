From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi: pm8001: build in relevant functions and code on PM8001_USE_MSIX
Date: Thu, 23 Mar 2017 10:16:02 +0100
Message-ID: <CAMGffEkffcSd961qC7OGubVQ2nYpv1ViGr4e6+ZxXg9diqfO3A@mail.gmail.com>
References: <20170322185004.1012-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36450 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbdCWJXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 05:23:13 -0400
Received: by mail-qk0-f181.google.com with SMTP id p22so34954592qka.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2017 02:23:08 -0700 (PDT)
In-Reply-To: <20170322185004.1012-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: lindar_liu <lindar_liu@usish.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Mar 22, 2017 at 7:50 PM, Colin King <colin.king@canonical.com> wrot=
e:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the misx and intx variables of the interrupt enable/disable
> helper functions are built in no matter what the setting of the
> macro PM8001_USE_MSIX.  Clean this up by just building in the
> necessary helper functions and calls to these functions depending on
> the setting of PM8001_USE_MSIX.  This addresses several dead code
> paths found by static analysis with CoverityScan.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 63 +++++++++++++++++++++-------------=
------
>  1 file changed, 33 insertions(+), 30 deletions(-)

Thanks Colin,

Mind to also change pm80xx_hw.c?

--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
