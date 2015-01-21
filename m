From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: module: fix module_refcount() return when running in a module exit routine
Date: Wed, 21 Jan 2015 16:00:29 +1030
Message-ID: <877fwgbszu.fsf@rustcorp.com.au>
References: <1421600146.2080.8.camel@HansenPartnership.com> <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au> <1421683701.2080.25.camel@HansenPartnership.com> <871tmqcmau.fsf@rustcorp.com.au> <1421774615.2080.88.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbAUXeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2015 18:34:11 -0500
In-Reply-To: <1421774615.2080.88.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> Actually, I don't think this is enough.  Some Australian once came up
> with a guide to APIs, and lectured on it at length, one of which was
> that the name should be the obvious use and it is unexpected that a
> refcount would go negative.  I think we could raise it from -6 on the
> API scale to +3 if we add some documentation like below.

Thanks, applied!

Cheers,
Rusty.
