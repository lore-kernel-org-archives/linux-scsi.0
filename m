From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC/RFT 3/4] convert sg
Date: Thu, 15 Sep 2005 12:24:48 -0500
Message-ID: <4329AE60.2030504@cs.wisc.edu>
References: <1126736390.16778.26.camel@max> <4329649A.6000406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63942 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030550AbVIORYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 13:24:47 -0400
In-Reply-To: <4329649A.6000406@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Mike Christie wrote:
> 
>>Convert sg to always to scatterlist IO.
>>
>>This is not the complete cleanup I wanted to do, but nothing should
>>be broken like in my past patches. st and osst can be converted to
>>use the same interface. Eventually, I would like to convert them
>>to use the blk_rq_map_user* functions but becuase of the
>>large requests and them reserving the buffers themselves, and
>>sg's mmap code I coverted them to use the map_kern_iov function
>>first.
> 
> 
> Thanks for keeping the sg driver's feature set. I'll
> start testing, ironically mostly on SATA disks :-)
> 

:) I found some bugs last night during testing. I will remake a patchset 
  today with my fixes and Chrisopth's and Jens's comments included.
