From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv3]scsi: don't fail zero length request too early
Date: Fri, 13 May 2016 11:55:48 -0700
Message-ID: <1463165748.2291.77.camel@HansenPartnership.com>
References: <CAMGffEmZMWSTSP3VRxn8K_ZWG3qvRWeKOjzPJN8V4ZZ8Fa_xGA@mail.gmail.com>
	 <1463147509.2291.1.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35234 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbcEMSzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 14:55:52 -0400
In-Reply-To: <1463147509.2291.1.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

On Fri, 2016-05-13 at 06:51 -0700, James Bottomley wrote:
> On Fri, 2016-05-13 at 10:07 +0200, Jinpu Wang wrote:
> > Hi James, and all,
> > 
> > I guess you're busy on other staff, so I create patch below as you
> > suggested, I think we also need this into stable.
> 
> No, I'll do it, but I just wanted to verify that we don't get into an
> infinite retry loop on any conditions.

OK, I checked, we're covered by the wait_for check at the bottom of the
switch which will automatically fail the command and not retry if we've
exceeded the timeout.

James


