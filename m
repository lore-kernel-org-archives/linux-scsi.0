From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Fri, 11 Mar 2005 16:20:45 -0800
Message-ID: <20050311162045.3ff73b6f.akpm@osdl.org>
References: <000001c524bc$d3c546a0$0b02a8c0@kw.de>
	<000c01c52626$32bae8d0$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:62694 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261761AbVCLAVA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 19:21:00 -0500
In-Reply-To: <000c01c52626$32bae8d0$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: e0815w@onlinehome.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, hch@infradead.org, arjan@infradead.org

"erich" <erich@areca.com.tw> wrote:
>
> I had modify "arcmsr" as your mention and ran it at 2.6.11 kernel.

Your patch omitted drivers/scsi/arcmsr/Makefile, so it doesn't compile.


