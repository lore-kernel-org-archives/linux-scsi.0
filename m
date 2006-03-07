From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Tue, 7 Mar 2006 14:00:12 -0500
Message-ID: <A59711AB-5397-4DFE-8CD3-33E5B637AD01@egenera.com>
References: <44071BA4.3030808@vlnb.net> <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com> <440DC897.6080408@vlnb.net> <2FBC50BB-5536-4E6F-9D02-7E9AE7174368@egenera.com> <440DD515.7070707@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:10981 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S932074AbWCGTA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 14:00:26 -0500
In-Reply-To: <440DD515.7070707@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org


On Mar 7, 2006, at 1:46 PM, Vladislav Bolkhovitin wrote:

> Steve Byan wrote:

>> As a data-point, some modern SCSI disks support queue depths in  
>> the  range of 128 to 256 commands.
>
> I rather asked about practical upper limit. From our observations a  
> Linux initiator could easily send 128+ commands, but usually less.  
> Looks like it depends from its available memory. Interested to know  
> the exact rule.

I don't know the rule. Obviously, it could change over time, and be  
different for different OS's.

Sounds to me like you might be trying to fix a busted initiator by  
changing the target behavior.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


