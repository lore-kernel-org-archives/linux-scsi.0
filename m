From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 16558] iSCSI Connection / Stability Problems
Date: Wed, 11 Aug 2010 12:35:00 +0900
Message-ID: <20100811123400M.fujita.tomonori@lab.ntt.co.jp>
References: <bug-16558-11613@https.bugzilla.kernel.org/>
	<201008110322.o7B3MavC000560@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44078 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab0HKDfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 23:35:41 -0400
In-Reply-To: <201008110322.o7B3MavC000560@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 11 Aug 2010 03:22:36 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> I have the same problem with the latter as the former, it makes no difference. 

Ok, please report it to both mailing lists respectively. But the log
that you sent is not about the latter. So please reports it with the
proper long to the latter.


> I should also mention that one particular symptom is that if I have an ssh
> connection open to the server,  it will stall. Keypresses aren't registered in
> the ssh session--- however,  if I bang on the console keyboard which is
> connected directly to the server via USB,  the ssh session comes back to life,
> spewing my keypresses back to me.

Hmm, sounds like a different problem. Needs to find what is the root
problem.
