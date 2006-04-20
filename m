From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 14/17] aic7xxx: ahc_pci_write_config() fix
Date: Thu, 20 Apr 2006 15:31:15 -0400
Message-ID: <1145561475.10009.2.camel@mulgrave.il.steeleye.com>
References: <200604190410.k3J4A3R4008248@shell0.pdx.osdl.net>
	 <4447D9F4.6000800@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41678 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751103AbWDTTbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 15:31:19 -0400
In-Reply-To: <4447D9F4.6000800@yk.rim.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, vda@ilport.com.ua

On Fri, 2006-04-21 at 03:59 +0900, Chiaki wrote:
> Can anyone explain with these incorrect(?) calls
> how the current aic7xxx has been working for me for a few months?
> Sorry, I am not using the latest and greatest kernel version, still...

The problem calls are in the resume method ... If you don't suspend your
system, you won't see them.

James


