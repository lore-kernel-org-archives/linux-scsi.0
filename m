From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: 05 Aug 2003 10:06:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060103209.2044.20.camel@fuzzy>
References: <1060042082.1985.53.camel@fuzzy>
	<1060102084.1188.10.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:57349 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S272881AbTHERGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 13:06:49 -0400
In-Reply-To: <1060102084.1188.10.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-08-05 at 09:48, Alan Cox wrote:
> On Maw, 2003-08-05 at 04:54, James Bottomley wrote:
> > transport errors (relevant to multi-path) and medium errors (relevant to
> > software raid).
> 
> And multimedia..

Yes, multi-media probably wants all error indications.

> > 5. Vendor value add for specific devices could be encoded both as
> > configuration (udev) pieces and plug-ins to the upper layer multi-path
> > driver to activate any proprietary vendor specific configuration options
> > that may be needed for specific solutions.
> 
> Vendors will try and arrange that their hotplug only works between
> devices entirely of their form. We must be careful not to encourage them
> in abusing their userbase.

I'm going to try to walk the tightrope here.  I'd like to encourage
vendors to be open, but I know we're trying to bring a lot of long time
proprietary solutions on board, so I'd like to begin by giving them the
flexibility to bring their own particular value add to the table.  If I
fall off the tightrope, I'm sure someone will catch me...

James



