From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: scsi/arm/fas216.c compile error
Date: Sun, 10 Feb 2008 16:15:16 +0200
Message-ID: <47AF06F4.2020807@panasas.com>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com> <20080210135851.GB25703@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751864AbYBJOQa@vger.kernel.org>
In-Reply-To: <20080210135851.GB25703@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 10 2008 at 15:58 +0200, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
>> It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
>>   [SCSI] arm: convert to accessors and !use_sg cleanup
>>
>> Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
>> to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
>> we finally managed a Tested-by:.
>>
>> I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
>> schedule.
> 
> Oh, I was ill for most of December, particularly at the time that you
> sent the patch, and by the time I recovered, it was buried in my mailbox.
> 
> Suggest you have some consideration for others who might not be able to
> do your beg and call at the immediate moment that you want it, and
> consider that their email management skills may not be as l33t as yours.
> 
Dear Russell.
You are right. I apologize. I was too trigger happy.
I should have resend the request. The patches were in scsi-pending and
in -mm. And I assumed it was all good. But it was not accepted into
scsi-misc and was somewhat forgotten.

I assure you, my email management skills are just as laking as yours. 
Just that my responsibility's are few.

Boaz
