From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: 05 Aug 2003 17:48:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060102084.1188.10.camel@dhcp22.swansea.linux.org.uk>
References: <1060042082.1985.53.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:39552 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S272867AbTHEQvv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 12:51:51 -0400
In-Reply-To: <1060042082.1985.53.camel@fuzzy>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Maw, 2003-08-05 at 04:54, James Bottomley wrote:
> transport errors (relevant to multi-path) and medium errors (relevant to
> software raid).

And multimedia..

> 5. Vendor value add for specific devices could be encoded both as
> configuration (udev) pieces and plug-ins to the upper layer multi-path
> driver to activate any proprietary vendor specific configuration options
> that may be needed for specific solutions.

Vendors will try and arrange that their hotplug only works between
devices entirely of their form. We must be careful not to encourage them
in abusing their userbase.


