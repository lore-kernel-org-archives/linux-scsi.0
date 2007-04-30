From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Mon, 30 Apr 2007 09:33:12 -0500 (CDT)
Message-ID: <20070430143312.74403DBA1@gherkin.frus.com>
References: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:58306 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423303AbXD3OdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 10:33:14 -0400
In-Reply-To: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
 "from James Bottomley at Apr 27, 2007 05:21:39 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Apologies to all concerned for an unfortunate delay in resolving this.
I chose "unwisely" when I picked a popular experimental distro's
2.6.20 kernel source as a base for my troubleshooting efforts.  The
resulting kernel panics when it tries to load the initial ramdisk, and
I don't have the patience to track down which of the turned-on-by-default
experimental configuration parameters might be causing the problem.

I'll go retrieve a more conservatively-configured source tree (closer to
what DSL-N uses) and start over...

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
