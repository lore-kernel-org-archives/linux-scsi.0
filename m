From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: CONFIG_BLK_DEV_BSG=n
Date: Fri, 14 Sep 2007 15:00:08 -0500
Message-ID: <1189800008.3343.21.camel@localhost.localdomain>
References: <598D5675D34BE349929AF5EDE9B03E27015558EA@az33exm24.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52772 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756092AbXINUAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 16:00:11 -0400
In-Reply-To: <598D5675D34BE349929AF5EDE9B03E27015558EA@az33exm24.fsl.freescale.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>
Cc: fujita.tomonori@lab.ntt.co.jp, paulus@samba.org, Gala Kumar-B11780 <kumar.gala@freescale.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Fri, 2007-09-14 at 12:50 -0700, Medve Emilian-EMMEDVE1 wrote:
> Which solution would you be more comfortable with?

The one which is currently in -mm is this one:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=49892223f7d3a2333ef9e6cbdd526676e1fc517a

James


