From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.13-rc5-mm1 doesnt boot on x86_64
Date: Mon, 08 Aug 2005 12:33:29 -0500
Message-ID: <1123522409.5019.0.camel@mulgrave>
References: <20050808094818.A17579@unix-os.sc.intel.com>
	 <20050808171126.GA32092@muc.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:33259 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932136AbVHHReG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 13:34:06 -0400
In-Reply-To: <20050808171126.GA32092@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Ashok Raj <ashok.raj@intel.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-08 at 19:11 +0200, Andi Kleen wrote:
> Looks like a SCSI problem. The machine has an Adaptec SCSI adapter, right?

The traceback looks pretty meaningless.

What was happening on the machine before this.  i.e. was it booting up,
in which case can we have the prior dmesg file; or was the aic79xxx
driver being removed?

James


