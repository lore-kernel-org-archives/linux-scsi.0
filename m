From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Regression impacts ServeRAID II on IBM xSeries 5500
Date: Tue, 28 Jul 2009 11:42:07 +0900
Message-ID: <20090728114207C.fujita.tomonori@lab.ntt.co.jp>
References: <4A6172F0.60707@davidnewall.com>
	<20090723110118N.fujita.tomonori@lab.ntt.co.jp>
	<4A69D341.8030908@davidnewall.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752886AbZG1DM2@vger.kernel.org>
In-Reply-To: <4A69D341.8030908@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davidn@davidnewall.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 Jul 2009 00:59:05 +0930
David Newall <davidn@davidnewall.com> wrote:

> >> My machine and assistance is at your disposal.  Rather than guess what
> >> information you want: what can I tell you?
> >>     
> >
> > What kernel version do you use, the latest git tree?
> 
> I was running Ubuntu's 2.6.28-13-server, but have reverted to their
> 2.6.27-10-server, that being the latest Ubuntu-provided version on which
> ipssend works. The patch which apparently introduced the regression is
> for 2.6.27-rc9, which is quite old. The regression was a year ago, and
> although I've found quite a few people who have the same problem, I
> haven't found any indication of the problem having been previously
> reported or bisected, so it's likely the latest version still has the
> problem. I am happy to try the latest version of you want.

I merged lots of changes to sg in 2.6.28. I fixed several bugs due to
it (the last one was merged in 2.6.31-rc3). Can you try the
2.6.31-rc4?
