From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
Date: Sun, 1 Feb 2009 11:03:35 -0800
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02753EB8@HQ-EXCH-5.corp.brocade.com>
References: <200901271854.n0RIs73a026759@swe37.brocade.com> <20090127221618.GA26480@infradead.org> <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com> <1233164662.3236.93.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E02753674@HQ-EXCH-5.corp.brocade.com> <20090131033238.GC2947@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:46502 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbZBATDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2009 14:03:39 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20090131033238.GC2947@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Greg KH Wrote:
> >
> > This is definitely helpful, thanks James!
> 
> Does this mean someone will send me a patch to add this to the
> drivers/staging/ tree?  Or should I just grab these patches and use
them
> to add them to the tree myself (preserving author attributes of
course)?
> 
> thanks,
> 
> greg k-h

Hi Greg,

Can you hold on adding this driver to driver/staging for a few weeks?
The driver I just submitted does compile and load but some important
features are not completed. We are still actively working on moving some
code to firmware to make it simpler and easier for code review. We
expect to get this done in next 2 or 3 weeks, at that time, we will
submit a complete driver which include the above mentioned change, and
all the code review comments we received in this submission.

Thanks!

Jing 
