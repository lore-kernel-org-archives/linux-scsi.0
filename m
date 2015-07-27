From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [for 4.1 PATCH resend] libsas: fix "sysfs group not found"
 warnings at port teardown time
Date: Mon, 27 Jul 2015 11:24:48 -0700
Message-ID: <CAPcyv4gByOjrgAoLrJFwU7onkQ-+BEL2p3XZc17iubSC8dsPYA@mail.gmail.com>
References: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1437589687.2171.44.camel@HansenPartnership.com>
	<CAPcyv4hTVCKU+SVAPPrne_EKuGdzuZjhpgpte26FVcCYT6_8wQ@mail.gmail.com>
	<1438010252.5441.21.camel@HansenPartnership.com>
	<CAPcyv4irtD_JgXEVkvhNak3s61kJCVzKADJ2s=nOsrT0qtzjXA@mail.gmail.com>
	<1438020423.5441.52.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37861 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbG0SYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2015 14:24:49 -0400
Received: by wibud3 with SMTP id ud3so127739456wib.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2015 11:24:48 -0700 (PDT)
In-Reply-To: <1438020423.5441.52.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Praveen Murali <pmurali@logicube.com>, linux-scsi <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Mon, Jul 27, 2015 at 11:07 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2015-07-27 at 08:48 -0700, Dan Williams wrote:
>> On Mon, Jul 27, 2015 at 8:17 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Wed, 2015-07-22 at 14:08 -0700, Dan Williams wrote:
>> >>   I don't have a libsas environment handy, I worked with Praveen to
>> >> validate the version as submitted if you want to re-work it.
>> >
>> > A couple of days ago, this was so urgent as to have to go outside the
>> > usual patch process ... now it's not important enough for you to bother
>> > working on it; which is it?
>>
>> Neither, it was a reviewed patch that was idling in the process.  I'm
>> still of the opinion that pinging Andrew in a case like this *is* the
>> expected process, unless there's a place I can check that a patch is
>> still in the application queue?
>
> I didn't ask you to justify your process, I asked you how important you
> thought the patch was mainly because of the conflicting signals you've
> sent.  I get that you think I should treat all your patches as important
> whether you do or not, but the world doesn't quite work like that: patch
> application is a process of triage.  Patches, like this, which have
> timing related issues potentially leading to races get looked at by me
> as the last reviewer.  The speed of review depends on several factors,
> but one of which is what type of user visible issue is this causing.
> The user visible effects of this are a nasty warning message and nothing
> more, I believe?  A useful indicator in this triage is how important the
> submitter thinks the patch is, which was originally why I asked.
>

That would be a question to Praveen.  It wasn't clear to me whether
this sysfs backtrace was a simply a warning or eventually fatal to the
box.
