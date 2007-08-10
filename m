From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.23-rc2-mm2
Date: Fri, 10 Aug 2007 14:35:01 +0200
Message-ID: <46BC5B75.80102@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:27341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbXHJMg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 08:36:57 -0400
Received: by nf-out-0910.google.com with SMTP id g13so236636nfb
        for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2007 05:36:55 -0700 (PDT)
In-Reply-To: <46BC3CB1.2090503@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Some new warnings here :

...

In file included from include/linux/blkdev.h:17,
                 from kernel/sched.c:45:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

...

In file included from include/linux/blkdev.h:17,
                 from mm/filemap.c:29:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

...

Some more of these , all from bsg.h:{67,71}

config there :

http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-5







