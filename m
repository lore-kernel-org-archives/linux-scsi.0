From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53_8xx_2: fixes two bugs related to chip reset
Date: Fri, 11 Jan 2008 13:52:29 -0700
Message-ID: <20080111205229.GQ18741@parisc-linux.org>
References: <20080109235944.34333eb6.krzysztof.h1@poczta.fm> <1199922703.3493.76.camel@localhost.localdomain> <20080110233118.d2b137ba.krzysztof.h1@poczta.fm> <1200005221.3141.118.camel@localhost.localdomain> <20080111215046.6c4a3c80.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36306 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYAKUwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 15:52:30 -0500
Content-Disposition: inline
In-Reply-To: <20080111215046.6c4a3c80.krzysztof.h1@poczta.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Fri, Jan 11, 2008 at 09:50:46PM +0100, Krzysztof Helt wrote:
> +			BUG_ON(!sym_data->io_reset);
> +			sym_data->io_reset = &eh_done;

Isn't that BUG_ON still the wrong sense?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
