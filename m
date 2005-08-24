From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 17:48:07 -0400
Message-ID: <430CEB17.3020203@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com> <20050822215316.GB8083@us.ibm.com> <430BB779.2060209@adaptec.com> <20050824171241.GB16652@us.ibm.com> <430CD2EF.8010108@adaptec.com> <20050824204214.GA21794@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19690 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932299AbVHXVsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 17:48:14 -0400
In-Reply-To: <20050824204214.GA21794@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org

On 08/24/05 16:42, Patrick Mansfield wrote:
>>And where does _it_ get it?
> 
> 
> You can write a program to supply it :)

Some of those would depend on the transport and I'd like
_transport_ things to "die" at _transport_ layer.

The transport layer would add as much as possible, then
SCSI Core, then sd then the block layer, then whoever is
on top.

Eventually you'd have a bunch of strings, which are labels,
with varied but ASCII contents.
 
>>Hey Patrick, is there a point to this thread?
> 
> 
> Yes, at this juncture a simplified explanation about udev rules.

Please go ahead.

>>If you have an idea, please go ahead and share and/or implement it.
>>If you're unclear on something please ask it directly.
> 
> I thought you were asking for details about udev ... your question was
> rather ambiguous.

Never did.

I was at a much, _much_, lower level.  Anyway, this is a rather
important issue which vendors want to have.  In fact it's very important
for them.

Let's take it up again in several days,

	Luben


