From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [patch 2.6.21-rc4-git] SCSI newstyle hotplug/coldplug support
Date: Wed, 21 Mar 2007 14:01:09 +0300
Message-ID: <46011075.6050608@tls.msk.ru>
References: <200703201736.09280.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:20187 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXCULBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2007 07:01:15 -0400
In-Reply-To: <200703201736.09280.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

David Brownell wrote:
> This teaches scsi devices how to support "new style" hotplug/coldplug:
> using a modalias sysfs attribute for coldplug, and MODALIAS environment
> variable for hotplug.

How this is different from http://marc.info/?t=115204542200002&r=1&w=2 and
earlier attempts to do the same?

/mjt
