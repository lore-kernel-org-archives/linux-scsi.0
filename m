From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Low-level reformat with different sector size: ?
Date: Fri, 29 Jun 2007 21:50:29 -0400
Message-ID: <4685B6E5.80204@torque.net>
References: <f638pe$it6$1@sea.gmane.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45555 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXF3Buw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2007 21:50:52 -0400
In-Reply-To: <f638pe$it6$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-scsi@vger.kernel.org

Matthias Urlichs wrote:
> Hello,
> 
> Yesterday I managed to buy a couple of SCA disks with a sector size of ...
> *drumroll* ... 524.
> 
> What's the easiest way to re-format these to use 512 bytes?
> Preferably without screwing up anything else on these things?

Umm, I hope you don't consider losing all the previous data
on the disks when a re-format is performed as "screwing up"?

Doug Gilbert
