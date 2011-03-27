From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Sun, 27 Mar 2011 19:02:25 +0900
Message-ID: <20110327185119V.fujita.tomonori@lab.ntt.co.jp>
References: <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
	<1301012333.4087.24.camel@mulgrave.site>
	<1301087690.6087.126.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab1C0KDA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2011 06:03:00 -0400
In-Reply-To: <1301087690.6087.126.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, 25 Mar 2011 14:14:50 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> What I am saying is that only the optional to implement iSCSI
> authentication *payloads* should have a request/response interface with
> userspace daemons for those types of auth libs that we always expect to

We don't need such interface (authentication *payloads* between kernel
and user spaces). All operations (including authentication) before
establishing a nexus should be done in userspace.
