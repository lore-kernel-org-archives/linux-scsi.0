From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fw: [Bugme-new] [Bug 8141] New: Adaptec 39320D and long boot
Date: Sun, 11 Mar 2007 15:52:54 -0800
Message-ID: <20070311155254.a76ad319.akpm@linux-foundation.org>
References: <20070307123335.d7e97db3.akpm@linux-foundation.org>
	<1173636225.3420.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813AbXCKXxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 19:53:09 -0400
In-Reply-To: <1173636225.3420.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, karaluh@tlen.pl, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

> On Sun, 11 Mar 2007 13:03:44 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Wed, 2007-03-07 at 12:33 -0800, Andrew Morton wrote:
> > 41-second delay when mounting root fs.
> 
> This sounds like a user configuration error.  The adaptec has a bus
> settle time in its initialisation path.  Originally it was 20s, hence
> for a D card (twin channel) it would take about 50s to come online
> (extra 5s to scan per channel).  There was a lot of argument about this,
> and the value was finally made configurable as
> 
> CONFIG_AIC79XX_RESET_DELAY_MS
> 
> I suspect you have this set to around 15000.  You can make the boot
> sequence shorter by reducing this value.  I believe Red Hat configures
> it down to the default 5000.
> 
> James

(cc's added)
