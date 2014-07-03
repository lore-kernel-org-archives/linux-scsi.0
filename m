From: Steven Haber <steven@qumulo.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 3 Jul 2014 09:57:32 -0700
Message-ID: <CAPK7rjdVM-Anw-uFc6RGCrwZko885vBGgbB+LehmuKF4r6nu5A@mail.gmail.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	<20140626150208.GA14887@infradead.org>
	<1403808734.6440.12.camel@dabdike>
	<20140627075553.GB21799@infradead.org>
	<CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
	<CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
	<20140701081510.GA14857@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49193 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaGCQ5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 12:57:33 -0400
Received: by mail-ob0-f172.google.com with SMTP id uy5so602280obc.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 09:57:32 -0700 (PDT)
In-Reply-To: <20140701081510.GA14857@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Both patches work fine -- zero uncommitted writes over several hundred
power cycles.

On Tue, Jul 1, 2014 at 1:15 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 11:45:31AM -0700, Steven Haber wrote:
>> Our qual rig is having some woes. I'll let you know how the test works
>> out after I finish resuscitating it.
>
> Might be worth to test that patch James send in reply then.  They should
> have an identical effect and James seems to prefer the version testing
> for the length.
>
