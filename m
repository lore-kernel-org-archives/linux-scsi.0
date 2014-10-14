From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Tue, 14 Oct 2014 12:42:26 -0400
Message-ID: <543D5272.5080102@interlog.com>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net> <20141011161110.GA16812@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net> <20141014111354.GA3022@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56881 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbaJNQmv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2014 12:42:51 -0400
In-Reply-To: <20141014111354.GA3022@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On 14-10-14 07:13 AM, Christoph Hellwig wrote:
> On Sat, Oct 11, 2014 at 10:06:47PM +0000, Elliott, Robert (Server Storage) wrote:
>> Thanks.  That's a bit better, but sg_reset can now run into
>> "No such device" errors.
>
> That's the -ENODEV we return if another reset is in progress.  Given
> that I suspect sg_reset is the prime if not only user of this interface
> I'm happy to change the error code we return here to anything Doug
> agrees to.

I don't mind if you change it. However I plan to release
sg3_utils-1.40 in the next 2 or 3 weeks, so that would
be the earliest a revised sg_reset would be available for
distros. Improving error reports is something I always
like to do (so ENODEV for the "in progress" case seems a
bit strident).

On the other hand, the existing sg_reset code with --no-esc
has been in place since sg3_utils-1.36 [20130531]. So there
is a good chance current distributions have that version or
later.

Doug Gilbert

