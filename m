From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 19:44:12 +0100
Message-ID: <AANLkTims4pYwuwU7UeOvgiXvr6CRBRUk8+juLKA3DpWm@mail.gmail.com>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
 <20110324074600L.fujita.tomonori@lab.ntt.co.jp> <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
 <20110324102939R.fujita.tomonori@lab.ntt.co.jp> <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
 <1301012333.4087.24.camel@mulgrave.site> <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
 <1301065611.4073.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57914 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1CYSoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 14:44:34 -0400
Received: by vws1 with SMTP id 1so996932vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 11:44:33 -0700 (PDT)
In-Reply-To: <1301065611.4073.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, Mar 25, 2011 at 4:06 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> Explain first what lock inversion problems you see ... those usually
> only happen if you have the in the kernel upcall thread waiting for
> completion.

In this context asynchronous upcalls have their problems too: the
in-kernel and the user space visible state may become inconsistent.
What will happen if processing of such notifications is delayed and
concurrently attempts are made from user space to act on these objects
? I'm afraid that could result in horrible race conditions.

Bart.
