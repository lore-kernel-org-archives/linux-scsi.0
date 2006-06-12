From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 15:05:19 -0500
Message-ID: <448DC8FF.5090008@cs.wisc.edu>
References: <8889.1149988615@bebe.enoyolf.org> <20060612190431.846310@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:14995 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932204AbWFLUFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 16:05:53 -0400
In-Reply-To: <20060612190431.846310@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@bebe.enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org

Doug Maxey wrote:
>> What is the struct cleanup though? typedef->just struct usage?
>>
> 
> mainly, yes. 

Ok. I am fine if you want to do that. For iscsi_tcp and friends we fixed
this, but nobody ever said anything about the typedef usage during the
initial qla4xxx postings so I thought we had been overly careful/picky.

For scsi I never saw anyone complain about the single file issue either.
However for the netdev review it looks like the qlogic net driver got
that comment and the typedef one.

What about the mixed case variable names and other junk? Some people get
a way with them and others don't. For scsi is the policy to not be that
picky or did some drivers sneak in?


> do we need to track the sparse types (__le*) for device 
> data?
> 

Yeah I think so. I do not think you were CCd on the coding style todo.
Qlogic and I sometimes drop you form CCs and forget to add you back on
later. Sorry about that.
