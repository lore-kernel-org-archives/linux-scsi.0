From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas -- add hibernation support
Date: Wed, 4 Jul 2007 20:21:36 +0200
Message-ID: <20070704182136.GA2731@elf.ucw.cz>
References: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59578 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140AbXGDSVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jul 2007 14:21:40 -0400
Content-Disposition: inline
In-Reply-To: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, sumant.patro@lsi.com

Hi!

> The megaraid_sas driver doesn't support the hibernation, the
> suspend/resume routine implemented to support the hibernation.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>

I'm glad to see first scsi driver to have hibernation support
:-). Appart for whitespace, patch looks ok to me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
