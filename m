From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 3/4] qla1280,qla2xxx: Remove display of transfersize
Date: Thu, 18 Oct 2007 14:05:21 -0700
Message-ID: <4717CA91.7030407@qlogic.com>
References: <11927248762034-git-send-email-matthew@wil.cx> <11927248763320-git-send-email-matthew@wil.cx> <4717AC9D.4040000@qlogic.com> <20071018201052.GA25831@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:37786 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXJRVEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 17:04:09 -0400
In-Reply-To: <20071018201052.GA25831@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> On Thu, Oct 18, 2007 at 11:57:33AM -0700, Seokmann Ju wrote:
>> Matthew Wilcox wrote:
>>> As part of their debug routines, both of these drivers print out the
>>> transfersize.  That's just unnecessary, particularly since neither driver
>>> actually uses it.
>> NACK for qla2xxx - I would rather change it to 'cmd->device->sector_size' instead of removing it.
>> A patch will be followed by.
> 
> I don't understand why you care to print it at this point.  If you know
> the device, you know the sector size, right?
As the debug message doesn't get displayed in normal situation, just wanted to keep as many information in the function as possible.

Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>

Thank you,
Seokmann

