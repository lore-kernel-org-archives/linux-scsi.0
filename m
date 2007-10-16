From: "Dave Milter" <davemilter@gmail.com>
Subject: Re: linux-2.6.23-mm1 crashed
Date: Tue, 16 Oct 2007 09:44:24 +0400
Message-ID: <2a382c6e0710152244r4b6e214dk93988263b193efa8@mail.gmail.com>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	 <2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
	 <20071014123101.208b102b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:40116 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779AbXJPFoZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 01:44:25 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2255543wah
        for <linux-scsi@vger.kernel.org>; Mon, 15 Oct 2007 22:44:24 -0700 (PDT)
In-Reply-To: <20071014123101.208b102b.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 10/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> I didn't notice that qemu was involved.  Does qemu have an emulator for the
> gdth hardware?
>

I think no, the kernel just probe exist or not hardware, and hangs after that.
