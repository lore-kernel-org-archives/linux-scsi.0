From: Yiannis Mavroukakis <jander@darthvader.us>
Subject: Re: legacy megaraid driver bug in mm-series
Date: Thu, 08 Sep 2005 08:56:25 +0100
Message-ID: <431FEEA9.60407@darthvader.us>
References: <0E3FA95632D6D047BA649F95DAB60E5703662B18@exa-atlanta> <20050907133355.54f3dd2d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail56.messagelabs.com ([193.109.254.67]:63960 "HELO
	mail56.messagelabs.com") by vger.kernel.org with SMTP
	id S1751335AbVIHH4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 03:56:09 -0400
In-Reply-To: <20050907133355.54f3dd2d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton wrote:

>"Ju, Seokmann" <sju@lsil.com> wrote:
>  
>
>>Hi Andrew,
>>On Wednesday, September 07, 2005 5:53 AM, Andrew Morton forwarded:
>>    
>>
>>>2.6.11-mm1:	works
>>>2.6.11-mm4:	works
>>>2.6.12-rc5-mm1:	will not compile
>>>2.6.12-rc6-mm1:	works
>>>2.6.12-mm1:	will not compile megaraid driver
>>>2.6.12-mm2:	broken
>>>2.6.13-mm1:	broken
>>>
>>>2.6.12:		works
>>>2.6.13:		works
>>>      
>>>
>>Is there any precedence rule on the kernels?.
>>
>>    
>>
>
>It's a bit weird, but the above are in chronological order.
>
>Time order:
>
>	2.6.12
>	2.6.13-rc1
>	2.6.13-rc2
>	2.6.13
>	2.6.14-rc1
>
>etc.  And -mm kernels are just the current Linus kernel with -mmX appended.
>
>  
>
>>I wonder which kernel is latest in between 2.6.12 and 2.6.12-mmx.
>>    
>>
>
>2.6.12-mmX
>
>  
>
>>I assume 2.6.12-mmx is later than 2.6.12.
>>    
>>
>
>Correct.
>
>  
>
2.6.13-mm1 doesn't work on my megaraid controller.

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
