From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 35/82] remove linux/version.h from
 drivers/scsi/cpqfcTSinit.c
Date: Fri, 29 Jul 2005 21:19:30 -0700
Message-ID: <20050729211930.392209b0.akpm@osdl.org>
References: <20050710193543.35.MfBvHx3206.2247.olh@nectarine.suse.de>
	<1122691434.5108.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:13223 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262870AbVG3EUg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 00:20:36 -0400
In-Reply-To: <1122691434.5108.30.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: olh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Sun, 2005-07-10 at 19:35 +0000, Olaf Hering wrote:
> > changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.
> > remove code for obsolete kernels
> 
> I can't seem to get any of these patches to apply:
> 
> Applying 'remove linux/version.h from drivers/scsi/cpqfcTSinit.c'
> 
> patching file drivers/scsi/cpqfcTSinit.c
> patch: **** malformed patch at line 4: #include <linux/config.h>
> 
> I've no idea what patch's problem is ... as far as I can tell there are
> no line breaks or illegal characters in the email.
> 

I suggest you not apply these patches - I have them all lined up and fixed
in -mm and we can do it in one hit post-2.6.13.
