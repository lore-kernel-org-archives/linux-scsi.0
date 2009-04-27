From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/6] fnic: add main file with module infrastructure,	fnic
 structure, Makefile
Date: Mon, 27 Apr 2009 11:05:28 -0500
Message-ID: <49F5D7C8.5050909@cs.wisc.edu>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>	 <20090418013232.24787.33309.stgit@feynman.nuovasystems.com> <1240847076.3387.20.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60858 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbZD0QF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 12:05:57 -0400
In-Reply-To: <1240847076.3387.20.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, linux-scsi@vger.kernel.org, jeykholt@cisco.com

James Bottomley wrote:
> On Fri, 2009-04-17 at 18:32 -0700, Abhijeet Joglekar wrote:
>> fnic_main.c: include module load and unload, PCI device probe, scsi-ml,
>> libFC and scsi-transport-fc registration and interfaces
>>
>> fnic.h: has fnic definition and other related data types
>>
>> Makefile:
>>
>> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
>> Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> I'm guessing this should be:
> 
> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
> Reviewed-by: Joe Eykholt <jeykholt@cisco.com>
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> ?
> 

I am not sure. If I had did some changes for the driver code and I also 
reviewed the driver and am ok with it but I am not the maintainer, what 
tag should I get?

For qla4xxx my Signed-off-by was added, and for cxgb3i I had just 
replied on the email where the patch was sent with a Acked-by.
