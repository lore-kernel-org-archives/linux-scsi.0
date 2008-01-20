From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Performance of SCST versus STGT
Date: Sun, 20 Jan 2008 10:36:18 +0100
Message-ID: <e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu> <479096D2.8090003@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:43683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYATJgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 04:36:18 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2933796wah.23
        for <linux-scsi@vger.kernel.org>; Sun, 20 Jan 2008 01:36:18 -0800 (PST)
In-Reply-To: <479096D2.8090003@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Vladislav Bolkhovitin <vst@vlnb.net>
Cc: stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Pete Wyckoff <pw@osc.edu>, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

On Jan 18, 2008 1:08 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> [ ... ]
> So, seems I understood your slides correctly: the more valuable data for
> our SCST SRP vs STGT iSER comparison should be on page 26 for 1 command
> read (~480MB/s, i.e. ~60% from Bart's result on the equivalent hardware).

At least in my tests SCST performed significantly better than STGT.
These tests were performed with the currently available
implementations of SCST and STGT. Which performance improvements are
possible for these projects (e.g. zero-copying), and by how much is it
expected that these performance improvements will increase throughput
and will decrease latency ?

Bart.
