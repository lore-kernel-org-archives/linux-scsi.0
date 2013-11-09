From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH 4/5] ata: Add APM X-Gene SATA serdes functions
Date: Fri, 8 Nov 2013 21:32:14 -0800
Message-ID: <CAPw-ZT=Xy8XRHc+BConWz22_7+67FqVuUfoB0DtZsUCjHeb05A@mail.gmail.com>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
	<1383949838-25106-2-git-send-email-lho@apm.com>
	<1383949838-25106-3-git-send-email-lho@apm.com>
	<1383949838-25106-4-git-send-email-lho@apm.com>
	<1383949838-25106-5-git-send-email-lho@apm.com>
	<20131109003821.GA22982@quad.lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:40748 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750951Ab3KIFcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 00:32:16 -0500
Received: by mail-pa0-f43.google.com with SMTP id hz1so3124956pad.16
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 21:32:15 -0800 (PST)
In-Reply-To: <20131109003821.GA22982@quad.lixom.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olof Johansson <olof@lixom.net>
Cc: tj@kernel.org, linux-scsi@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>

Hi,

Forgot to run checkpatch on this one. It will be fixed in the new version.

-Loc

On Fri, Nov 8, 2013 at 4:38 PM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Nov 08, 2013 at 03:30:37PM -0700, Loc Ho wrote:
>> Signed-off-by: Loc Ho <lho@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> Signed-off-by: Suman Tripathi <stripathi@apm.com>
>> ---
>>  drivers/ata/sata_xgene_serdes.c | 1982 +++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 1982 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/ata/sata_xgene_serdes.c
>
> To start with:
>
> This patch is riddled with checkpatch errors from whitespace stuff.
>
> It completely lacks any kind of patch description.
>
>
> -Olof
