From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 20:42:35 -0500
Message-ID: <1190770955.8707.23.camel@localhost.localdomain>
References: <1190768402.8707.20.camel@localhost.localdomain>
	 <20070925065233Q.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58414 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbXIZBmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 21:42:38 -0400
In-Reply-To: <20070925065233Q.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 2007-09-26 at 10:28 +0900, FUJITA Tomonori wrote:
> On Tue, 25 Sep 2007 20:00:02 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > Andrew asked that I provide a status report of pending updates.  The
> > list is attached below.  It's pretty much driver updates and minor bug
> > fixes.  The main functionality changes are Kay's sysfs updates and the
> > shift of the ULD attachement towards the block prep function.
> 
> Can we make new 'supporrted_mode' and 'active_mode' attributes look
> better?
> 
> http://marc.info/?l=linux-scsi&m=118991196128245&w=2

Sure, but Jeff's suggestion was a good one to avoid me having to change
hundreds of files.  Could you roll it up and resubmit?

James


