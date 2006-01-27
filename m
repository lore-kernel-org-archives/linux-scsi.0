From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Fri, 27 Jan 2006 04:52:43 -0600
Message-ID: <43D9FB7B.7010806@cs.wisc.edu>
References: <1138157882.11692.31.camel@max> <20060126032844.GA16123@cs.umn.edu> <43D9F9C3.4050703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37265 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964964AbWA0Kwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 05:52:50 -0500
In-Reply-To: <43D9F9C3.4050703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave C Boutcher <sleddog@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Dave C Boutcher wrote:
> 
>> On Tue, Jan 24, 2006 at 08:58:02PM -0600, Mike Christie wrote:
>>
>>> The following patches begin to add the infrastructure for the SCSI
>>> Userspace target framework. We were not sure about what James meant by
>>> some of his comments, so rather than getting to far we want to post a
>>> for any block device (well, someone could do a libata type of target for
>>> any transport).
>>
>>
>>
>> Nit question...I notice those patches are from git. Do you have a git
>> tree for stgt?  I was about to start figuring out subversion based on
>> the berlios page.
>>
> 
> No git tree. I have not uploaded it to svn yet. Tomo and I are still 
> converting userspace. We had a tiny mishap with different versions 
> getting merged and me basing my stuff on the wrong code. But for svn I 

basing my userspace stuff on the wrong code I mean
