From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 07 Jan 2005 17:22:43 +0100
Message-ID: <1105114963.4179.35.camel@laptopd505.fenrus.org>
References: <a06100533be0463eff562@[129.98.90.227]>
	 <008001c4f4d4$364d0d80$111015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:57614 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261497AbVAGQWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 11:22:54 -0500
In-Reply-To: <008001c4f4d4$364d0d80$111015ac@ericmoore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, Maurice Volaski <mvolaski@aecom.yu.edu>

On Fri, 2005-01-07 at 09:16 -0700, Eric Moore wrote:
> The mpt fusion driver supports 256 luns, 
> and it seems your device supports more than that.
> 
> Eric
> > scsi: host 1 channel 0 id 0 lun 0x5a5a5a5a5a5a5a5a has a LUN larger 
> > than currently supported.
> > 

actually 5a5a5a5a5a is a slab poison pattern, something is using
uninitialized memory....


