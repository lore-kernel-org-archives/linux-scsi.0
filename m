From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/5] kill scsi_wait_req
Date: Fri, 16 Sep 2005 02:45:27 -0500
Message-ID: <432A7817.6000100@cs.wisc.edu>
References: <1126845602.9276.46.camel@max> <200509160940.10846@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58058 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161116AbVIPHp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 03:45:27 -0400
In-Reply-To: <200509160940.10846@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

Rolf Eike Beer wrote:
> Mike Christie wrote:
> 
>>cpqfc is the last user of scsi_wait_req. It is too broken to even
>>test patches to convert it to other functions though.
>>This patch just kills scsi_wait_req and adds to the list
>>of things that are broken on cpqfc. I was not sure what
>>the proper thing to do in this case when the driver
>>is so broken.
> 
> 
> If you want to test it you'll find the needed patches on 
> http://opensource.sf-tec.de/kernel/. I found someone with this hardware (or 
> he found me) and we're testing this.
> 
> If you refuse to touch it I'll try to fix it up once your patches went into 
> mainline.
> 

I actually had a patch. Let me see if I can dig it up so you can test.
