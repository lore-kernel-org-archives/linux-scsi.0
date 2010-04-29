From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Wed, 28 Apr 2010 20:45:51 -0500
Message-ID: <4BD8E4CF.1030501@cs.wisc.edu>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>	 <4BD7D7A1.3040507@cs.wisc.edu>	 <B065E21A-3DB2-4303-B0DC-FB41F97F0225@qlogic.com> <1272497102.14756.46.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37884 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0D2BqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 21:46:25 -0400
In-Reply-To: <1272497102.14756.46.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "ravi.anand" <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Randy Dunlap <randy.dunlap@oracle.com>

On 04/28/2010 06:25 PM, James Bottomley wrote:
>> Are you going to pull in all the other patches except this one ?
>> We can resubmit this one once Mike get a chance to review it.
>
> Um, so I understood the comment to mean that Mike is still waiting for
> you to comment on his questions and sugestions for patches 9,8,6,1 of
> the original 12 patch series from 6 April ... unless I missed them?
>

They sent me mails offlist for my review comments. The reworked patches 
they are sending in this patcheset are a result of that work, so all the 
patches but "[PATCH 09/11] qla4xxx: Added support for ISP82XX" are ok. 
It might be ok, but I have not looked at it in depth. I was trying to 
say before that I have not looked at it because we had been working on 
the other patches.

> As long as this 11 patch series reviews and applies independently, I'm
> fine with dropping this and taking the rest.

They should. I applied all but the 9/11 one, built them and ran them ok.
