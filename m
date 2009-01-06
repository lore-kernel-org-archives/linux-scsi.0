From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Tue, 06 Jan 2009 17:49:04 +0200
Message-ID: <49637D70.1060709@panasas.com>
References: <1231251436-9777-1-git-send-email-bharrosh@panasas.com>	<20090106234303H.fujita.tomonori@lab.ntt.co.jp>	<49637117.50108@panasas.com> <20090107001206N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:22439 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873AbZAFPtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 10:49:08 -0500
In-Reply-To: <20090107001206N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, akpm@linux-foundation.org

FUJITA Tomonori wrote:
> On Tue, 06 Jan 2009 16:56:23 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Tue,  6 Jan 2009 16:17:16 +0200
>>> Why do we need in-kernel test suite?
>> It must be in kernel, because it tests the in-kernel library.
>> However it could be in it's own Module, which makes it more
>> complicated, but doable.
> 
> Why do we need the code to tests the in-kernel library?
> 
> I expect that you guys have tested the osd in-kernel library heavily
> and will. I don't think people want to do the same. Then why do we
> need to have the test suite in mainline?
> 

one - There are things that can regress. Lots of stuff in current
kernel are only used by OSD, like bidi and varlen. all the way down
to LLDs. So this should be a regression test for future kernels.

two - To test compatibility, some thing is broken, the test can help
pinpoint the problems. So it's a debugging tool.

Sure, the lib itself is heavily tested but this is to test the
round trip.

> 
>> Please note that the submitted tests are the bare minimum and
>> will be enhanced in the future. Perhaps later when the test grow
>> I will put them in their own module.
> 
> If you can have it as a module, it's very easy for you guys to keep it
> out-of-mainline.

I have it out-of-mainline for a long time ;). I can do that. I thought that
I should provide a minimal test, so developers can check if they broke
something. If no one wants it I'll remove it.

Thanks
Boaz
