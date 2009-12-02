From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] scsi_dh_emc: fix mode select request setup
Date: Wed, 02 Dec 2009 14:46:24 -0600
Message-ID: <4B16D220.90108@cs.wisc.edu>
References: <1259785728-20419-1-git-send-email-michaelc@cs.wisc.edu> <1259786182.5430.138.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53451 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZLBUqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 15:46:31 -0500
In-Reply-To: <1259786182.5430.138.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

James Bottomley wrote:
> On Wed, 2009-12-02 at 14:28 -0600, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> This patch fixes the request setup code for mode selects. I got the fixes from
>> Hannes Reinecke while trying to hunt down some problems and merged it
>> into one patch. I am sending it because Hannes is busy with other things.
> 
> So that should be From: Hannes Reineke at the top then?  (I can fix it
> up if it is)
> 

Yeah, I think it should. I was not sure, because I merged his fixes into 
one patch and wrote the email. He wrote all the code though. I am just 
forwarding the fixes since he was busy.
