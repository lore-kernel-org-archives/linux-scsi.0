From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 20:02:06 +0100
Message-ID: <e2e108260802051102y1b02bcdic5ea9c45caee9964@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <47A89889.9060701@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:2145 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbYBETCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 14:02:08 -0500
Received: by el-out-1112.google.com with SMTP id v27so886792ele.23
        for <linux-scsi@vger.kernel.org>; Tue, 05 Feb 2008 11:02:07 -0800 (PST)
In-Reply-To: <47A89889.9060701@Voltaire.COM>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@voltaire.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Feb 5, 2008 6:10 PM, Erez Zilber <erezz@voltaire.com> wrote:
> One may claim that STGT should have lower performance than SCST because
> its data path is from userspace. However, your results show that for
> non-IB transports, they both show the same numbers. Furthermore, with IB
> there shouldn't be any additional difference between the 2 targets
> because data transfer from userspace is as efficient as data transfer
> from kernel space.
>
> The only explanation that I see is that fine tuning for iSCSI & iSER is
> required. As was already mentioned in this thread, with SDR you can get
> ~900 MB/sec with iSER (on STGT).

My most recent measurements also show that one can get 900 MB/s with
STGT + iSER on an SDR IB network, but only for very large block sizes
(>= 100 MB). A quote from Linus Torvalds is relevant here (February 5,
2008):

    Block transfer sizes over about 64kB are totally irrelevant for
99% of all people.

Please read my e-mail (posted earlier today) with a comparison for 4
KB - 64 KB block transfer sizes between SCST and STGT.

Bart Van Assche.
