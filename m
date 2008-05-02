From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 18:06:59 +0200
Message-ID: <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:19585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbYEBQHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:07:01 -0400
Received: by fg-out-1718.google.com with SMTP id 19so978008fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 09:07:00 -0700 (PDT)
In-Reply-To: <20080502155525.GA16353@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>> Regarding out-of-tree modules: this is just a preparatory step before
>> submitting SCST for inclusion in the mainstream kernel.
>
> And what crackpipe did you smoke to thing we'd put duplicated target
> framework in?

Why are you so aggressive ? I didn't insult you in any way.

Regarding inclusion of SCSI target code in the mainline, this subject
has already been discussed extensively in the past
(http://lkml.org/lkml/2008/1/23/134). The conclusion was clear: SCST
is faster than any other existing iSCSI target for Linux (IET, STGT,
LIO), stable, well maintained and the most standards compliant target.
Why do you want to reopen this discussion ?

James Bottomley clearly expressed in that thread that he doesn't want
to maintain two SCSI target frameworks. So what I propose is that SCST
is included in the mainline and afterwards that it is evaluated
whether or not it is desirable to keep other target code in the
mainline kernel.

Bart.
