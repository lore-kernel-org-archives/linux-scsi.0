From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Tue, 15 Jul 2003 12:52:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030715125233.458b8c29.akpm@osdl.org>
References: <20030713141556.13650fdb.akpm@osdl.org>
	<20030714101041.65de0d72.akpm@osdl.org>
	<20030714203510.GE1317@beaverton.ibm.com>
	<200307152143.26772.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:54981 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269570AbTGOTpY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 15:45:24 -0400
In-Reply-To: <200307152143.26772.arvidjaar@mail.ru>
List-Id: linux-scsi@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: andmike@us.ibm.com, James.Bottomley@steeleye.com, hch@infradead.org, linux-scsi@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>
> Well, the reason is simple and is fixed in patch sent two days ago to lkml - 
> fs/partitions/check.c:register_disk does not add .../disc if media capacity 
> == 0 - i.e. no media present.

Please resend a tested, documented patch for that.

Things are slow at present - Linus is away, the big conference is next
week, etc.  So please be patient, keep working this and keep hassling folks
over it, OK?

