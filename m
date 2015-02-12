From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] [RESEND] wd719x: add missing .module to wd719x_template
Date: Thu, 12 Feb 2015 16:32:36 +0100
Message-ID: <201502121632.36962.linux@rainbow-software.org>
References: <1423485501-5992-1-git-send-email-linux@rainbow-software.org> <1423753743.2147.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:45681 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbbBLPc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2015 10:32:58 -0500
In-Reply-To: <1423753743.2147.4.camel@HansenPartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Thursday 12 February 2015, James Bottomley wrote:
> On Mon, 2015-02-09 at 13:38 +0100, Ondrej Zary wrote:
> > wd719x_template is missing the .module field, causing module refcount
> > not to work, allowing to rmmod the driver while in use (mounted
> > filesystem), causing an oops.
> >
> > Set .module to THIS_MODULE to fix the problem.
>
> This requires a cc to stable, doesn't it?

Should go into 3.19-stable.

-- 
Ondrej Zary
