From: Douglas Gilbert <dougg@torque.net>
Subject: Re: LLDD: scatterlists only?
Date: Mon, 15 Aug 2005 16:21:37 +1000
Message-ID: <43003471.5000108@torque.net>
References: <20050814232446.58676.qmail@web51604.mail.yahoo.com> <1124063460.18802.27.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:23429 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932096AbVHOGVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 02:21:41 -0400
In-Reply-To: <1124063460.18802.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: michaelc@cs.wisc.edu, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2005-08-14 at 16:24 -0700, Luben Tuikov wrote:
> 
>>Did someone have a patch or was there a talk
>>that SCSI Core is moving towards sending _only_ scatterlists
>>down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))
> 
> 
> Yes, you can already see the beginnings in the -mm tree.
> 
> Jens is maintaining a block tree with this in here:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=rq-map
> 
> And I have a scsi-block-2.6 tree based off this here:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-block-2.6.git;a=summary
> 
> The missing (and frankly really nasty) pieces are pulling all the sg
> handling out of sg and st, but fortunately Mike Christie is working on
> that.

James,

I haven't looked at what would be involved with the sg
driver but it is good to hear Mike C. is working on it.

Hopefully scsi_cmnd::buffer and bufflen get _less_ generic
names in the process.

Doug Gilbert
