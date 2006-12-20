From: Bgs <bgs@bgs.hu>
Subject: Re: [Bugme-new] [Bug 7717] New: Tapes unreadable after unload
Date: Wed, 20 Dec 2006 13:55:33 +0100
Message-ID: <458932C5.4000807@bgs.hu>
References: <200612201031.kBKAVIJS005240@fire-2.osdl.org> <20061220025058.70d3d4ea.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bgs.hu ([195.228.254.245]:44284 "HELO mail.bgs.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965047AbWLTNCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 08:02:17 -0500
In-Reply-To: <20061220025058.70d3d4ea.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>



Andrew Morton wrote:
>>     Kernel Version: tested 2.6.17 through 2.6.29 with various results
> 
> I assume that means 2.6.17 and 2.6.19 failed.

I tested it with 2.6.17 through 2.6.19 including subversions (like 
2.6.17.3 and such). I found that 2.6.19 works and also found two other 
version in the line that work. The other about 4-5 version that I have 
tried, did not work. The works/not works is not consistent as I found 
2.6.17.x kernel that did work and 2.6.18 that did not.

If the problem is known, I'd also like to know what the problem was as I 
need to recover two tapes that are inaccessible now. (LTO3 400GB tapes 
so there was no time to erase all data even if something near the 
beginning of the tape is bad).


>>             Status: NEW
>>           Severity: blocking
>>              Owner: io_scsi@kernel-bugs.osdl.org
>>          Submitter: bgs@bgs.hu
>>
>>
>> Most recent kernel where this bug did *NOT* occur: 2.6.19
> 
> And that means that 2.6.19 did not fail.

Right now I'm using 2.6.19 and it works. Haven't tried it with 2.6.19.1 
yet though.
