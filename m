From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] scsi: replace uses of __constant_{endian}
Date: Thu, 29 Jan 2009 15:13:30 -0800
Message-ID: <1233270810.5594.10.camel@brick>
References: <1233265895.5594.3.camel@brick>
	 <20090129230926.GB37589@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:9615 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZA2XNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 18:13:32 -0500
Received: by wf-out-1314.google.com with SMTP id 27so174770wfd.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2009 15:13:32 -0800 (PST)
In-Reply-To: <20090129230926.GB37589@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-01-29 at 15:09 -0800, Andrew Vasquez wrote:
> On Thu, 29 Jan 2009, Harvey Harrison wrote:
> 
> > The base versions handle constant folding now.  Almost entirely
> > in qla2xxx/qla4xxx.
> 
> Do the same semantics apply to htonl()?  As, I'd rather see the
> changes from __constant_htonl() -> cpu_to_be32() be __constant_htonl()
> -> htonl():

They do, htonl is a simple wrapper around cpu_to_be32.  This was just a stupid
search/replace in the two drivers.  If you'd prefer it done differently, feel free.

If it's just the htonl bits I'll do a respin.

Harvey

