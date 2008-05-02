From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 18:57:10 +0200
Message-ID: <e2e108260805020957k2390b151t7fe6beacc9fe8b34@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <20080502161629.GF14976@parisc-linux.org>
	 <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com>
	 <20080502164905.GH14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:45934 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbYEBQ5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:57:12 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1199223fkq.5
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 09:57:11 -0700 (PDT)
In-Reply-To: <20080502164905.GH14976@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 2, 2008 at 6:49 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> Can you really not locate drivers/scsi/scsi_tgt_lib.c in the tree?  I
> appreciate that there's a lot of files in the drivers/scsi/ directory,
> but c'mon.  I had no idea what it was called and it took about 30
> seconds to find them once I realised you wanted all the work to be done
> for you.

Thanks for looking this up. Would it be an acceptable approach if the
SCST code is modified such that it calls the code inside
drivers/scsi/scsi_tgt_lib.c whenever this is appropriate ?

Bart.
