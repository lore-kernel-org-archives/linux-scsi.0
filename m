From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 4/4] arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries
Date: Wed, 20 Nov 2013 19:48:20 +0100
Message-ID: <201311201948.20682.arnd@arndb.de>
References: <1384905197-3566-1-git-send-email-lho@apm.com> <1384905197-3566-5-git-send-email-lho@apm.com> <528CF956.3040104@cogentembedded.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3KTSsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 13:48:55 -0500
In-Reply-To: <528CF956.3040104@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Wednesday 20 November 2013, Sergei Shtylyov wrote:
> > --- a/arch/arm64/boot/dts/apm-storm.dtsi
> > +++ b/arch/arm64/boot/dts/apm-storm.dtsi
> > @@ -193,5 +193,33 @@
> >                       reg = <0x0 0x17000014 0x0 0x100>;
> >                       mask = <0x1>;
> >               };
> > +
> > +             sataphy0: sataphy@1f210000 {
> 
>     The nodes should better be named like "sata-phy@1f210000" to better comply 
> with the "ethernet-phy" name we see in the ePAPR spec.

Well, since the phy can be used for other devices, I'd rather name it just
"phy", or possibly "serdes". The fact that it happens to be used for sata
here should not influence the naming when both the phy driver and the hardware
are completely generic.

	Arnd
