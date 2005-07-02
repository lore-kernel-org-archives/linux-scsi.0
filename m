From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx regression occuring after 2.6.12 final
Date: Sat, 02 Jul 2005 13:01:31 -0400
Message-ID: <1120323691.5073.12.camel@mulgrave>
References: <1120085446.9743.11.camel@localhost>
	 <1120318925.21935.9.camel@localhost>  <1120321322.5073.4.camel@mulgrave>
	 <1120322788.22046.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31398 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261194AbVGBRBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2005 13:01:34 -0400
In-Reply-To: <1120322788.22046.2.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Vroon <chainsaw@gentoo.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>

On Sat, 2005-07-02 at 17:46 +0100, Tony Vroon wrote:
> What does that asynchronous line mean? I  see that on all kernels that
> do not boot properly. 2.6.12; 2.6.12.1 and 2.6.12.2 do not display it,
> and boot just fine.
> 
> target0:0:0: asynchronous

It means the target is sending data asynchronously (the slowest and
safest speed).

Could you try booting with aic7xxx=verbose to see what the device thinks
its negotiating?

Thanks,

James


