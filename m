From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 15 Oct 2007 15:53:08 +0200
Message-ID: <471370C4.8000803@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:12194 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761330AbXJON4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 09:56:52 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1261549nfb
        for <linux-scsi@vger.kernel.org>; Mon, 15 Oct 2007 06:56:50 -0700 (PDT)
In-Reply-To: <47125633.3030404@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>> Compile tested and applies cleanly to 2.6.23.
>> I don't have this hardware anymore and cannot run test these patches.
> 
> I can test these patches on an aic7892 controller later on today if you want.

Works fine for me tested on :

03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m [9005:008f] (rev 02)


Gabriel
