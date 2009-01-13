From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Tue, 13 Jan 2009 19:21:35 +0200
Message-ID: <496CCD9F.2000401@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org>	<1231802758.27151.18.camel@localhost.localdomain>	<496C9ABE.8060300@garzik.org>	<20090113140328.3aab5a35@lxorguk.ukuu.org.uk>	<496CA26E.1080708@garzik.org> <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27640 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753267AbZAMRVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 12:21:42 -0500
In-Reply-To: <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Alan Cox wrote:
>>> Now in my experience that is a *dumb* question because the answer is
>>> obvious...
>> The choice is between "new magic OSD fs" and "new fs that used to be 
>> ext4, before we hacked it up".
>>
>> "existing one you trust" is not an option...
> 
> No it isn't. The choice is existing technology followed by a "thank you
> goodbye Mr OSD salesman".
> 
> I'm not saying we shouldn't work on an OSD file system and I'm glad IBM
> folks are but that it can be done slowly. 

IBM is not working on OSD for a long time now. We at open-osd are.
That is me and Benny (abit) and other people that hang on the mailing-list
So it is mostly Panasas these days.

On git.open-osd.org we are hosting various OSD projects mainly the submitted
work plus inherited code from OSC, which is not active anymore. as of Q3 2008.

Also for most fs folks an OSD
> emulator testing might not be a bad idea - say one stacked on ext3 8)
> 

One of the projects on open-osd.org is the OSC's osd-target which is based
on scsi tgt framework and implements an OSD in user-mode over any local
filesystem. It supports any SCSI transport supported by tgt that is: iscsi,
fcoe, iser, kernel-tgt. This is what we test against. I have just been porting
that project to freebsd. It as a very small foot print compared to, lets say NFS.

Thanks
Boaz
