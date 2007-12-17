From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 13:05:23 +0000
Message-ID: <20071217130523.7e9c88bb@the-village.bc.nu>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<20071217031841.f483e5ac.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45549 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754279AbXLQNMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 08:12:21 -0500
In-Reply-To: <20071217031841.f483e5ac.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Filippos Papadopoulos <psybases@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> initio doesn't seem to have a maintainer...
> 
> Are you able to identify any earlier kernel which worked OK?
> 
> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> for that device we can take a look.

If I remember rightly the fixes for this went into the scsi tree a couple
of months ago. The patch is in the -mm tree as well. No idea why its
gotten stuck as an obvious one liner.

Alan
