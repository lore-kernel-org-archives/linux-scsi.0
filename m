From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Mon, 18 Jan 2010 13:18:05 +0900
Message-ID: <20100118131653L.fujita.tomonori@lab.ntt.co.jp>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
	<201001151223.o0FCNGa8002934@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51544 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0ARESK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jan 2010 23:18:10 -0500
In-Reply-To: <201001151223.o0FCNGa8002934@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 15 Jan 2010 12:23:16 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> What does sg_tablesize in scsi_host_template mean?
> It means the max sg entry number which the HW can handle once?

Yes. A driver should set it to hardware limit.

Can you close this bug report on bugzilla.kernel.org? The bug is not
in mainline. If you have any further questions related with this
topic, please send to linux-scsi mailing list instead of using the
kernel bug tracker.

Thanks,
