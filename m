From: linux-kernel@jmbreuer.net
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 12:00:35 +0100
Message-ID: <4B028253.1040407@jmbreuer.net>
References: <bug-14563-11613@http.bugzilla.kernel.org/>	<200911161919.nAGJJZ94028105@demeter.kernel.org> <20091117141437G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKQLAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 06:00:52 -0500
In-Reply-To: <20091117141437G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@jmbreuer.net, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi

FUJITA Tomonori wrote:
>>> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
>>> spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
>>> is hit shortly thereafter.
>>>
>> Can you try this with debugging enabled in st? (Edit st.c to
>> '#define DEBUG 1' and recompile the module.) This might give more 
>> information about the source of the EIO and the code path it uses.
> 
> Sorry about that bug.
> 
> Looks like that st drivers messes up memory management but the log
> doesn't give enough information.
> 
> As Kai suggested, please enable the debug option and send the new log.

I've attached the relevant information to
http://bugzilla.kernel.org/show_bug.cgi?id=14563

Thanks!


So long,
   Joe
