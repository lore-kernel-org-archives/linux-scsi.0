From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Sat, 09 Feb 2008 12:01:16 -0600
Message-ID: <1202580076.4254.24.camel@localhost.localdomain>
References: <47ADC74B.9080009@control.aau.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52207 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYBISB1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 13:01:27 -0500
In-Reply-To: <47ADC74B.9080009@control.aau.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kim =?ISO-8859-1?Q?H=F8jgaard-Hansen?= <kimhh@control.aau.dk>
Cc: erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com


On Sat, 2008-02-09 at 16:31 +0100, Kim H=C3=B8jgaard-Hansen wrote:
> The following was reported by Joshua Hoblitt on Gentoo bugzilla when
> using the arcmsr driver (see https://bugs.gentoo.org/208493)
>=20
> When starting up the Areca RAID card http pass through proxy called
> archttp dmesg is completely filled with messages as:
>=20
> WARNING: at arch/x86/kernel/pci-dma_64.c:169 dma_free_coherent()
> Pid: 8232, comm: archttp64 Not tainted 2.6.24-gentoo #1

Could you check git head, please; I think it's fixed upstream.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
