From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Thu, 18 Oct 2007 12:19:34 +0100
Message-ID: <200710181219.34951.vda.linux@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com> <471370C4.8000803@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:1722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbXJRLUR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 07:20:17 -0400
Received: by ug-out-1314.google.com with SMTP id z38so407720ugc
        for <linux-scsi@vger.kernel.org>; Thu, 18 Oct 2007 04:20:15 -0700 (PDT)
In-Reply-To: <471370C4.8000803@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Andrew, James,

On Monday 15 October 2007 14:53, Gabriel C wrote:
> >> Compile tested and applies cleanly to 2.6.23.
> >> I don't have this hardware anymore and cannot run test these patches.
> > 
> > I can test these patches on an aic7892 controller later on today if you want.
> 
> Works fine for me tested on :
> 
> 03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m [9005:008f] (rev 02)

I hope this is enough for these patches to be accepted.

If it is not, please let me know what do I need to do more.
--
vda
