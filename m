From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6 patch make struct scsi_dh_devlist's static
Date: Mon, 11 Aug 2008 11:00:19 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0808111058590.3462@nehalem.linux-foundation.org>
References: <1218477013.16794.7.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYHKSA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 14:00:57 -0400
In-Reply-To: <1218477013.16794.7.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, Chandra Seetharaman wrote:
>
> This patch makes several needlessly global struct scsi_dh_devlist's 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

This is not a valid sign-off chain.

Was the patch originally done by Adrian? If so, where is the

	From: Adrian Bunk <bunk@kernel.org>

at the top?

And since you're forwarding it, you should be signing off on it, not just 
acking it. Otherwise, the next person in the chain can't sign off on it 
and take it.

		Linus
