From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 17 Nov 2005 12:08:16 -0500
Message-ID: <437CB900.7020102@hp.com>
References: <91888D455306F94EBD4D168954A9457C04F0AFDA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:32670 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S932425AbVKQRBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 12:01:21 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C04F0AFDA@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Michael Renner <michael.renner@geizhals.at>, linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:

>On Thursday, November 17, 2005 7:53 AM,  Alan D. Brunelle wrote:
>  
>
>>It doesn't surprise me that a different .config or hardware 
>>change would 
>>affect this. If I understand the problem correctly, then it 
>>depends upon 
>>timing - and changing things (hw or sw) could affect the outcome.
>>
>>The posting by
>>
>>The following works for me - but as noted previously, it may 
>>be suspect 
>>in general: I'm concerned about the indefinate delay (theoretical).
>>
>>    
>>
>
>Please use the patch I posted last night, apply to 2.6.15-rc1-git4.
>It addresses this issue.  
>
>Here is the URL to this patch:
>
>http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282408101&w=2
>
>Eric Moore
>LSI Logic
>
>
>  
>
FYI - I did try it earlier this morning with 2.6.14.2 and it did *not* 
fix the issue. I will see about updating to 2.6.15-rc1-git4, and trying 
that again...

Alan
