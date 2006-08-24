From: Thiemo Seufer <ths@networkno.de>
Subject: Re: Bug#366730: qla1280 bugfix in limbo?
Date: Thu, 24 Aug 2006 18:28:45 +0100
Message-ID: <20060824172845.GC2887@networkno.de>
References: <F3598542BAC24B4783B7A440D45522FF04B5D899@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bender.bawue.de ([193.7.176.20]:19664 "EHLO bender.bawue.de")
	by vger.kernel.org with ESMTP id S1030416AbWHXRaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Aug 2006 13:30:16 -0400
Content-Disposition: inline
In-Reply-To: <F3598542BAC24B4783B7A440D45522FF04B5D899@usahm236.amer.corp.eds.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bailey, Scott" <scott.bailey@eds.com>, 366730@bugs.debian.org
Cc: linux-scsi@vger.kernel.org

Bailey, Scott wrote:
> Just tuning in briefly to report:
> 
> 1. I have been running my 3-processor Alphaserver 4100 with Ian's patch
> http://bugzilla.kernel.org/show_bug.cgi?id=6275 for a little over a
> month now, first with 2.6.16 and now with 2.6.17, and it continues to
> work like a champ. I very much would like to see this fix incorporated
> into the Debian kernel or preferably upstream, since my DLT drive is
> pretty much useless without it.
> 
> 2. Unfortunately, I see no sign that anybody has looked at the kernel
> bugzilla report above.
> 
> Is there anything I can do to help move things along?

Send the patch with description and Signed-Off-By: line to
linux-scsi@vger.kernel.org.


Thiemo
