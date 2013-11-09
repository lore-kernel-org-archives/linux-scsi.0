From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH 2/5] arm64: Add APM X-Gene SATA DTS binding
Date: Fri, 8 Nov 2013 21:33:04 -0800
Message-ID: <CAPw-ZTmYWbVHhU-sqMqKZZxAYKteoRJa4+S0HnpUfxGFrmh_7g@mail.gmail.com>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
	<1383949838-25106-2-git-send-email-lho@apm.com>
	<1383949838-25106-3-git-send-email-lho@apm.com>
	<20131109003919.GB22982@quad.lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:41630 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750951Ab3KIFdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 00:33:06 -0500
Received: by mail-pd0-f180.google.com with SMTP id p10so2996540pdj.25
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 21:33:04 -0800 (PST)
In-Reply-To: <20131109003919.GB22982@quad.lixom.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olof Johansson <olof@lixom.net>
Cc: tj@kernel.org, linux-scsi@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>

 Hi,

I will add description on the next version.

-Loc

On Fri, Nov 8, 2013 at 4:39 PM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Nov 08, 2013 at 03:30:35PM -0700, Loc Ho wrote:
>> Signed-off-by: Loc Ho <lho@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> Signed-off-by: Suman Tripathi <stripathi@apm.com>
>> ---
>>  arch/arm64/boot/dts/apm-storm.dtsi |   73 ++++++++++++++++++++++++++++++++++++
>>  1 files changed, 73 insertions(+), 0 deletions(-)
>
> Technically this patch doesn't add a binding (the binding is just the
> documentation part), it updates the device tree with the SATA devices.
>
> Also, again: Patch description! Not optional.
>
>
> -Olof
