From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical
	address >16Mb used for aha1542" at boot time
Date: 19 Feb 2004 21:18:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077243517.2164.61.camel@mulgrave>
References: <20040218171212.0eb6618a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:38333 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267688AbUBTCSo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 21:18:44 -0500
In-Reply-To: <20040218171212.0eb6618a.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, molitor@uni-bonn.de

On Wed, 2004-02-18 at 20:12, Andrew Morton wrote:
> thank you very much for your work on Linux. Today, I came across a
> problem; sorry, I have failed in trying to spot the cause...
> 
> [1.] Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used
> for aha1542" at boot time on my box.

Could you replace the panic with a BUG() statement and make sure you
have CONFIG_KALLSYMS set, that should give us a backtrace showing where
the bad kernel allocation is.

Thanks,

James


