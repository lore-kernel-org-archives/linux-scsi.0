From: "David S. Miller" <davem@redhat.com>
Subject: Re: block layer sg, bsg
Date: Wed, 4 Aug 2004 07:52:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804075215.155c06ac.davem@redhat.com>
References: <20040804085000.GH10340@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47794 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266187AbUHDOyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 10:54:17 -0400
In-Reply-To: <20040804085000.GH10340@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


When you pass data structures in via {read,write}{,v}() system calls,
you make it next to impossible for the CONFIG_COMPAT layer to cope
with this.

Please consider another way to pass in those sg_io_* things.
