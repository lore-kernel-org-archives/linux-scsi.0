From: Andi Kleen <ak@suse.de>
Subject: Re: 64bit DMA in i2o_block
Date: 22 Sep 2006 12:54:29 +0200
Message-ID: <p73lkoci32y.fsf@verdi.suse.de>
References: <4513A87F.8040809@sw.ru> <4513B783.70008@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:14555 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932173AbWIVKyj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 06:54:39 -0400
In-Reply-To: <4513B783.70008@shadowconnect.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-scsi@vger.kernel.org, devel@openvz.org

Markus Lidel <Markus.Lidel@shadowconnect.com> writes:
> 
> I believe it's a driver issue. Do you have a testing-system where you
> could try out the appended patch?

So it would bug instead? 

Can you please just get rid of that CONFIG? Such things shouldn't 
be CONFIGs, but have a suitable default. In particular drivers
running under 64bit should always support 64bit DMA.

-Andi
