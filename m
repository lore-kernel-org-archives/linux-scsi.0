From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
Date: Mon, 29 Oct 2012 13:45:16 +0100
Message-ID: <1351514716.1339.15.camel@x61.thuisdomein>
References: <1348219723.1581.5.camel@x61.thuisdomein>
	 <1351506978.1339.8.camel@x61.thuisdomein>
	 <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-29 at 12:17 +0000, James Bottomley wrote:
> the aic7xxx_old driver is in deep maintenance; I don't think anyone can
> actually test changes to it anymore, so we just keep it around unchanged
> for the odd really old card that can't be driven by the current driver.
> For this reason, we tend only to do tested bug fixes to it because
> no-one will notice if any error is introduced.
> 
> mvsas has a maintainer: poke them harder

According to MAINTAINERS that's you. Is Xiangliang Yu perhaps the actual
maintainer?

> and aic94xx is currently
> maintainerless, so it will depend on someone finding the time to test.

Thanks,


Paul Bolle
