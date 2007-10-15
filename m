From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 15 Oct 2007 12:25:39 +0100
Message-ID: <200710151225.39624.vda.linux@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:62863 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764574AbXJOLZt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 07:25:49 -0400
Received: by ug-out-1314.google.com with SMTP id z38so852943ugc
        for <linux-scsi@vger.kernel.org>; Mon, 15 Oct 2007 04:25:47 -0700 (PDT)
In-Reply-To: <47125633.3030404@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sunday 14 October 2007 18:47, Gabriel C wrote:
> > Compile tested and applies cleanly to 2.6.23.
> > I don't have this hardware anymore and cannot run test these patches.
> 
> I can test these patches on an aic7892 controller later on today if you want.

I'd appreciate that.

Do you, by any chance, use aic94xx driver too (drivers/scsi/aic94xx/*)?
After i'm done with aic7xxx, I may attack this one.

> BTW while you seems to care about this driver could you have a look at :
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=3062 ?!?

I am a desktop Linux user, so far I don't use suspend at all. Sorry.
--
vda
