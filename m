From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] Common header file for FC definitions
Date: Tue, 08 Jan 2008 10:46:51 -0500
Message-ID: <47839AEB.3090003@emulex.com>
References: <20080108080924.GA6993@schmichrtp.de.ibm.com> <20080108131403.GA9643@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37769 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154AbYAHPtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:49:10 -0500
In-Reply-To: <20080108131403.GA9643@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, robert.w.love@intel.com



Christoph Hellwig wrote:
> On Tue, Jan 08, 2008 at 09:09:36AM +0100, Christof Schmitt wrote:
>> zfcp has a couple of definitions to describe the FC protocol. Grepping
>> through the complete source tree shows that e.g. the lpfc module makes
>> similar private definitions. It think that it would make sense to
>> introduce a global header file for FC related definitions that each FC
>> driver can use.
>>
>> The attached patch contains some definitons that i found in zfcp and
>> could be reused by other drivers.
>>
>> What do others think? Would this be useful?
> 
> This is a very good idea.  It might make more sense to have the more or
> less complete defintions for the fc protocol in the header.  Robert &
> folks have been working on a software fc stack part as the fcoe header
> so they might have one to contribute.

I Agree - A common header for standard FC definitions would be a good thing.

That said, we have to be a little lenient on when drivers convert over to
the standard headers as there's likely code change required.

-- james s
