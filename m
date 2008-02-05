From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 10:18:11 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802051016240.9374@woody.linux-foundation.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>  <1201639331.3069.58.camel@localhost.localdomain>  <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>  <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
 <e2e108260802050825u68ef2ee9m6e085acb6b474fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbYBESTA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 13:19:00 -0500
In-Reply-To: <e2e108260802050825u68ef2ee9m6e085acb6b474fe@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Vladislav Bolkhovitin <vst@vlnb.net>, Vu Pham <vuhuong@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>



On Tue, 5 Feb 2008, Bart Van Assche wrote:
> 
> Results that I did not expect:
> * A block transfer size of 1 MB is not enough to measure the maximal
> throughput. The maximal throughput is only reached at much higher
> block sizes (about 10 MB for SCST + SRP and about 100 MB for STGT +
> iSER).

Block transfer sizes over about 64kB are totally irrelevant for 99% of all 
people.

Don't even bother testing anything more. Yes, bigger transfers happen, but 
a lot of common loads have *smaller* transfers than 64kB.

So benchmarks that try to find "theoretical throughput" by just making big 
transfers should just be banned. They give numbers, yes, but the numbers 
are pointless.

			Linus
