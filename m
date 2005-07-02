From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx regression occuring after 2.6.12 final
Date: Sat, 02 Jul 2005 13:33:33 -0400
Message-ID: <1120325613.5073.16.camel@mulgrave>
References: <1120085446.9743.11.camel@localhost>
	 <1120318925.21935.9.camel@localhost>  <1120321322.5073.4.camel@mulgrave>
	 <1120322788.22046.2.camel@localhost>  <1120323691.5073.12.camel@mulgrave>
	 <1120324426.21967.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49318 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261227AbVGBRdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2005 13:33:39 -0400
In-Reply-To: <1120324426.21967.1.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Vroon <chainsaw@gentoo.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>

On Sat, 2005-07-02 at 18:13 +0100, Tony Vroon wrote:
> wscsi0: target 0 using asynchronous transfers
> [vendor information follows; Fujitsu MAP 36.7GB drive]

There should be more debugging information after this as the device goes
through domain validation, isn't there?

James 

