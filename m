From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi_run_queue oops
Date: Fri, 23 Dec 2005 14:41:23 -0600
Message-ID: <1135370483.3728.45.camel@mulgrave>
References: <20051223201227.GA7020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31424 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161045AbVLWUlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:41:31 -0500
In-Reply-To: <20051223201227.GA7020@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 15:12 -0500, Dave Jones wrote:
> I got a report from a user who periodically sees
> an oops in this function in our 2.6.14.3 based update.
> 
> Does this look familiar to anyone?

Yes, this is the fix:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34ea80ec6a02ad02e6b9c75c478c18e5880d6713

James


