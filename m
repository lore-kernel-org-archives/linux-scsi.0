From: Andrew Morton <akpm@osdl.org>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 10:26:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210102603.0c835212.akpm@osdl.org>
References: <20040204024512.5bf68428.akpm@osdl.org>
	<20040210110417.GB4010@tpkurt.garloff.de>
	<20040210112658.GC4010@tpkurt.garloff.de>
	<20040210133932.A3870@infradead.org>
	<20040210154751.GH4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:40172 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266187AbUBJSXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 13:23:24 -0500
In-Reply-To: <20040210154751.GH4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com

Kurt Garloff <garloff@suse.de> wrote:
>
> Since when is 4k huge?
>  Sorry, I don't see any benefit in adding complexity to avoid a 4k array.

Well yes, but we do have lib/idr.c which I believe does what you need.  It
is simple to use.
