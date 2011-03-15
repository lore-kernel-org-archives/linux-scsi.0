From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Tue, 15 Mar 2011 14:08:58 -0400
Message-ID: <4D7FAB3A.9060903@garzik.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6> <4D7FA620.10004@garzik.org> <20110315175533.GA8291@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44859 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab1COSJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2011 14:09:01 -0400
Received: by qyk7 with SMTP id 7so2701505qyk.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2011 11:09:01 -0700 (PDT)
In-Reply-To: <20110315175533.GA8291@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On 03/15/2011 01:55 PM, Christoph Hellwig wrote:
> On Tue, Mar 15, 2011 at 01:47:12PM -0400, Jeff Garzik wrote:
>> Let's get this driver into staging for 2.6.39, if it isn't going to
>> hit the merge window for 2.6.39.
>>
>> It would lame for such [presumably] high volume hardware to be in
>> neither the main kernel, nor staging, at 2.6.39 release time.
>
> What's the point of staging?  That just causes tons of poinless churn.
> Linus has made it clear that normal high volume hardware drivers can go
> in after the merge window.  So let's just polish it for another few
> weeks and then put it in where it belongs.

That's fine... if that really happens.

It seemed like this was turning into another driver that would get held 
outside the kernel until it's "perfect."  If that is the case, Linus has 
also made it clear we should get drivers for high volume, shipping 
hardware into the kernel, even if its staging, if the alternative is to 
deny users the driver.

	Jeff



