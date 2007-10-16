From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 13:37:19 -0700
Message-ID: <20071016133719.00301d11.akpm@linux-foundation.org>
References: <200710112011.22000.rob@landley.net>
	<20071015014503.GF9715@thunk.org>
	<200710150304.00901.rob@landley.net>
	<200710152337.45252.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbXJPVgY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:24 -0400
In-Reply-To: <200710152337.45252.nickpiggin@yahoo.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: rob@landley.net, tytso@mit.edu, James.Bottomley@steeleye.com, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, suparna@in.ibm.com, piggin@cyberone.com.au

On Mon, 15 Oct 2007 23:37:44 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Would an oom-kill-someone-now sysrq be of help, I wonder?

Is already there: sysrq-f.
