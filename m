From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: SCSI target subsystem
Date: Sat, 3 May 2008 16:48:08 +0200
Message-ID: <e2e108260805030748yea75e79xf421b70fc4a625e1@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
	 <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
	 <20080503095314.GX14976@parisc-linux.org>
	 <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
	 <20080503132846.GA14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:57266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYECOsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 10:48:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1330400fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 03 May 2008 07:48:09 -0700 (PDT)
In-Reply-To: <20080503132846.GA14976@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

On Sat, May 3, 2008 at 3:28 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> Once Vladislav is ready for his project to be merged, let him approach
> us and ask.  I don't know if he considers his project ready for merging.
> Did he ask you for his help?  It's generally considered rather rude to
> merge someone else's code without their consent.  The way you tried to
> get it merged was unhelpful and, if Vladislav were less skillful a
> communicator, could have actively hindered getting it merged.

You'd better verify your assumptions before you take them for truth. I
asked Vladislav for permission by private e-mail before I posted the
scsi_execute_async_fifo() patch. Did try I to merge this code without
Vladislav's consent ? No. Anyone can see that I kept Vladislav and the
scst-devel mailing list in CC.

Let us return to the actual topic of this thread. Does the above mean
that you agree with inclusion of SCST in the mainline kernel ? It
still has to be decided who will maintain the mainline kernel SCSI
target code. In the past James wrote that he does not really have the
time for this. Until now the only one who volunteered to maintain such
a subsystem is Vladislav.

Bart.
