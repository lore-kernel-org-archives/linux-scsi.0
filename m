From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2.6.24] sym53c8xx_2 modpost section mismatch fix
Date: Sat, 26 Jan 2008 19:12:05 +0100
Message-ID: <20080126181205.GA25319@uranus.ravnborg.org>
References: <200801261803.m0QI3Fen025895@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:41042 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYAZSL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 13:11:57 -0500
Content-Disposition: inline
In-Reply-To: <200801261803.m0QI3Fen025895@harpo.it.uu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Jan 26, 2008 at 07:03:15PM +0100, Mikael Pettersson wrote:
> Building 2.6.24 with
> 
> # CONFIG_HOTPLUG is not set
> CONFIG_SCSI_SYM53C8XX_2=y
> 
> results in the following during modpost:
> 
> WARNING: vmlinux.o(.text+0x14b36c): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_set_cam_result_error')
> 
> because sym2_io_error_detected() calls sym2_remove(), which is marked __devexit.
> 
> Fixed by removing the __devexit from sym2_remove().
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
> Resend. Previously reported against 2.6.24-rc6 on 2007-12-15.

Fixed in upstream kernel by
commit: 864473bbbbcbe99e95a57ad496894768cd77a567

	Sam
