From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH update 2] SCSI: explain the hidden scsi_wait_scan
 Kconfig variable
Date: Mon, 22 Jun 2009 09:57:01 +0100
Message-ID: <20090622095701.72c22150@lxorguk.ukuu.org.uk>
References: <4A384FE4.9090703@gmail.com>
	<20090617021254.GQ19977@parisc-linux.org>
	<tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
	<1245338486.7586.13.camel@mulgrave.site>
	<20090618165926.GA13229@uranus.ravnborg.org>
	<tkrat.da2728358fccf96e@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47423 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbZFVIz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 04:55:58 -0400
In-Reply-To: <tkrat.da2728358fccf96e@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 18 Jun 2009 21:03:23 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to the unconditionally installed module and its
> Kconfig symbol.

How about the other possibility. People keepmaking it tunable because it
makes sense for it to be tunable. Far better IMHO to make it tunable "if
EMBEDDED"

