From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 0/5] ata: Add APM X-Gene SATA controller support
Date: Tue, 12 Nov 2013 18:30:22 +0100
Message-ID: <2501719.LnLBBqadQB@amdc1032>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
 <3056580.hyyOnlSqg9@amdc1032> <5282589C.2090606@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17258 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KLRaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 12:30:35 -0500
In-reply-to: <5282589C.2090606@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel@lists.infradead.org, Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, Suman Tripathi <stripathi@apm.com>, Tuan Phan <tphan@apm.com>, linux-ide@vger.kernel.org


Hi Sergei,

On Tuesday, November 12, 2013 08:34:36 PM Sergei Shtylyov wrote:
> Hello.
> 
> On 12-11-2013 19:40, Bartlomiej Zolnierkiewicz wrote:
> 
> > Please remember to include linux-ide@vger.kernel.org on CC: for ATA patches.
> 
> > Also from the quick look it seems that:
> > - patch #4 ("ata: Add APM X-Gene SATA serdes functions") should come before
> >    patch #3 ("ata: Add APM X-Gene SATA driver") as code in patch #3 depends
> >    on the code in patch #4
> > - patch #5 ("Documentation: Add documentation for APM X-Gene SATA DTS
> >    binding") should come before patch #2 ("arm64: Add APM X-Gene DTS entry
> >    for SATA controllers") or (even better) just be merged into patch #2
> 
>     No, if it has to be merged then to the driver patch, not .dts patch.

Oh, yes.  Driver patch is where these bindings are actually introduced.

Also .dts patch (adding actual users of bindings) should ideally come last.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

