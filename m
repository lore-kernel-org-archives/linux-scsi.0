From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator
Date: Wed, 01 Jun 2005 22:32:30 -0700
Message-ID: <429E99EE.3020108@yahoo.com>
References: <429E15CD.2090202@yahoo.com> <200506011654.11362.pmcfarland@downeast.net> <429E23E3.8000606@yahoo.com> <200506020046.02295.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.mail.sc5.yahoo.com ([66.163.170.6]:24727 "HELO
	smtp108.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261362AbVFBFc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2005 01:32:29 -0400
In-Reply-To: <200506020046.02295.chrivers@iversen-net.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Christian Iversen wrote:
> On Wednesday 01 June 2005 23:08, Alex Aizman wrote:
> 
>>Patrick McFarland wrote:
>>
>>>On Wednesday 01 June 2005 04:08 pm, Alex Aizman wrote:
>>>
>>>>This is open-iscsi/linux-iscsi-5 Initiator. This submission is ready for
>>>>inclusion into mainline kernel.
>>>
>>>Awesome! So is this complete enough so I can, say, play DVDs from one box
>>>using an ATAPI DVD drive in another box?
>>
>>Yep, that's what iSCSI is for, in part. You'll need iSCSI target to connect
>>to the SCSI backend, e.g. http://iscsitarget.sourceforge.net/
> 
> 
> This is really, really good work. Please keep it up :-)
> 
> I'm very much looking forward to comparing this to DVD-over-NBD, which works 
> fine, except when you need to change the disc. The NBD server locks the drive 
> when it's running, and you need to restart both client and server after a 
> disc change.
> 
> Briefly, what are the security features available? I assume I can do simple 
> things like only allow access to an IP range (can I?), but what about more 
> complex things like encryption?
> 

Briefly: in-band authentication at connection level is supported. You will not 
find it in the submitted code, it's all in user space, where it should be. IPsec 
encryption, as well as data integrity and confidentiality, is not supported yet. 
According to RFC, IPsec is a must to implement and optional to use. It's a 
feature, it can be added.
