From: Brian King <brking@us.ibm.com>
Subject: Re: How to map between /dev/sdX and dev/sgX devices?
Date: Thu, 19 Aug 2004 15:58:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41251473.4060809@us.ibm.com>
References: <C8CF60CFC4D8A74E9945E32CF096548A022148EE@silver.nane.netapp.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:906 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267399AbUHSU63 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 16:58:29 -0400
In-Reply-To: <C8CF60CFC4D8A74E9945E32CF096548A022148EE@silver.nane.netapp.com>
List-Id: linux-scsi@vger.kernel.org
To: "Reilley, Peter" <Peter.Reilley@netapp.com>
Cc: linux-scsi@vger.kernel.org

Reilley, Peter wrote:
>>-----Original Message-----
>>From: Arjan van de Ven [mailto:arjanv@redhat.com]
>>Sent: Thursday, August 19, 2004 3:13 PM
>>To: Reilley, Peter
>>Cc: linux-scsi@vger.kernel.org
>>Subject: Re: How to map between /dev/sdX and dev/sgX devices?
>>
>>
>>On Thu, 2004-08-19 at 20:35, Reilley, Peter wrote:
>>
>>>What is the correct way to find the corresponding scsi generic
>>>device given the scsi disk node name?   I have a situation
>>>where I must issue SCSI pass thru commands to a specific
>>>/dev/sdX node.  
>>
>>don't..... use SG_IO on the device directly
>>
> 
> 
> I don't think that this will work for me.
> I must support the 2.4 kernel as well as the 2.6 kernel.

Does sg_map work for you?

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

