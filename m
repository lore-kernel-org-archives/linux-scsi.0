From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: IO performance test on the tcm-vhost scsi
Date: Fri, 15 Jun 2012 11:35:03 +0100
Message-ID: <CAJSP0QU3pCo+kj8B8WvLX-zijcOxb=JXZB7DK0K952W4M8vF7Q@mail.gmail.com>
References: <1339582392.24309.15.camel@mengcong>
	<1339614481.13709.354.camel@haakon2.linux-iscsi.org>
	<1339667854.28851.14.camel@mengcong>
	<1339706508.12064.31.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60928 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2FOKfF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2012 06:35:05 -0400
In-Reply-To: <1339706508.12064.31.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: mc@linux.vnet.ibm.com, qemu-devel@nongnu.org, target-devel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, Anthony Liguori <anthony@codemonkey.ws>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jun 14, 2012 at 9:41 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Btw, I'll likely end up doing this conversion to realize the performance
> benefits when testing with raw flash backends, but I'm more than happy
> to take a patch ahead of that if you have the extra cycles to spare.

This was mentioned on target-devel a little while ago.  Unfortunately
I'm busy, the chance of a patch appearing from me is low, sorry.  If I
do get some cycles to tackle it I'll let you know first so we don't
duplicate work.

Stefan
