From: Dan Merillat <harik.attar@gmail.com>
Subject: Re: Megaraid lockup on 2.6.[7-8]
Date: Sat, 7 Aug 2004 12:26:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c0c06790040807092682a9ef0@mail.gmail.com>
References: <c0c067900408061855df4dcae@mail.gmail.com> <1091882205l.7352l.1l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.202]:5460 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S263626AbUHGQ0M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2004 12:26:12 -0400
Received: by mproxy.gmail.com with SMTP id 73so69695rnk
        for <linux-scsi@vger.kernel.org>; Sat, 07 Aug 2004 09:26:12 -0700 (PDT)
In-Reply-To: <1091882205l.7352l.1l@serve.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Did you consider power supply instability? Temperature problems?

Given that it's kept in a 70 degree machine room, I don't think it's
temperature related.

It's a 450 watt redundant powersupply.  It's possible that it has
failed, but unlikely. (both halves
are independant)

Wouldn't power supply/thermal problems manifest as random errors,
though?   Memory generally
fails the same way if it's a specific address flaking out (and that
address is in kernel space) but
I've already replaced it.

Also, I checked the archives and I'm not the only one that's getting
this.  Apparently it's a 2.6 specific problem, 2.4 did not have it.

What is the latest driver for a LSI Megaraid Express 500?  As I said,
2.20 seems to be only for
the U320/SATA cards, or at least it dosn't detect mine.
