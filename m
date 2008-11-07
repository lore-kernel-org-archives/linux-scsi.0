From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 13:41:35 -0500
Message-ID: <49148BDF.9050707@redhat.com>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYKGSmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2008 13:42:10 -0500
In-Reply-To: <20081107183636.GB29717@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>"Martin K. Petersen" <m>

Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 01:09:48PM -0500, Ric Wheeler wrote:
>   
>> I don't think that trim bugs should be that common - we just have to be  
>> very careful never to send down a trim for any uncommitted block.
>>
>>     
>
> The trim code probably deserves a very aggressive unit test to make
> sure it works correctly, but yeah, we should be able to control any
> trim bugs.
>
>   
>> Simple is always good, but I still think that the coalescing (even basic  
>> coalescing) will be a critical performance feature.
>>     
>
> Will we be able to query the device and find out its TRIM/UNMAP
> alignment requirements?  There is also a balanace between performance
> (at least if the concern is sending too many separate TRIM commands)
> and giving the SSD more flexibility in its wear-leveling allocation
> decisions by sending TRIM commands sooner rather than later.
>
> 	     	     	  	   	  	 - Ted
>   

T10 is still working on the proposal for how to display unmap related 
information for SCSI, so we don't even have a consistent way to find 
this out today for this population.

Not sure what is possible for the ATA devices,

Ric

