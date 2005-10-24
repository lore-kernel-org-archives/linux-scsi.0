From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 4/2] HCIL drivers update; sdev_printk
Date: Sun, 23 Oct 2005 22:36:26 -0500
Message-ID: <1130124986.3437.56.camel@mulgrave>
References: <20051023024104.GA20128@havoc.gtf.org>
	 <20051023195128.GA12102@havoc.gtf.org>
	 <20051023214034.GA15599@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62882 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750938AbVJXDg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 23:36:28 -0400
In-Reply-To: <20051023214034.GA15599@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-10-23 at 17:40 -0400, Jeff Garzik wrote:
> Yet more driver work.  Some bugs added (and noted).
> 
> Added sdev_printk() to save typing.

If you can unify this with the sdev_prink work here

http://marc.theaimsgroup.com/?l=linux-scsi&m=112827155625203

This can probably be applied independently

James


