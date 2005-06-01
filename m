From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator
Date: Wed, 01 Jun 2005 14:08:51 -0700
Message-ID: <429E23E3.8000606@yahoo.com>
References: <429E15CD.2090202@yahoo.com> <200506011654.11362.pmcfarland@downeast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.mail.sc5.yahoo.com ([66.163.170.7]:24660 "HELO
	smtp109.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261306AbVFAVI4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 17:08:56 -0400
In-Reply-To: <200506011654.11362.pmcfarland@downeast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick McFarland <pmcfarland@downeast.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>

Patrick McFarland wrote:
> On Wednesday 01 June 2005 04:08 pm, Alex Aizman wrote:
> 
>> This is open-iscsi/linux-iscsi-5 Initiator. This submission is ready for 
>> inclusion into mainline kernel.
> 
> 
> Awesome! So is this complete enough so I can, say, play DVDs from one box 
> using an ATAPI DVD drive in another box?
> 

Yep, that's what iSCSI is for, in part. You'll need iSCSI target to connect to
the SCSI backend, e.g. http://iscsitarget.sourceforge.net/
