From: David Miller <davem@davemloft.net>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Thu, 05 Apr 2007 15:36:49 -0700 (PDT)
Message-ID: <20070405.153649.104035809.davem@davemloft.net>
References: <200704052213.l35MDRRR015981@cichlid.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57802
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767233AbXDEWgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2007 18:36:50 -0400
In-Reply-To: <200704052213.l35MDRRR015981@cichlid.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aab@cichlid.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Andrew Burgess <aab@cichlid.com>
Date: Thu, 5 Apr 2007 15:13:27 -0700

> David, do you see any other problems with scsi_send_eh_cmnd?
> 
> I've switched back to 2.6.18 which seems to not oops 
> and am happy to try patches.

Does 2.6.20 with my patch OOPS too?  Does reverting my patch
make the oops go away?

If reverting my patch makes the OOPS go away, we need to
verify if page_address() is returning crap for some reason
or the length is wrong.
