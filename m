From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 7 Mar 2011 13:41:11 +0900
Message-ID: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
References: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
	<4D55A684.9060208@linux.vnet.ibm.com>
	<1297542446.29128.0.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44988 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1CGEl2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2011 23:41:28 -0500
In-Reply-To: <1297542446.29128.0.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: brking@linux.vnet.ibm.com, nab@linux-iscsi.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Sat, 12 Feb 2011 14:27:26 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> > Disregard my previous comment. It looks like current client should handle reservations
> > just fine without any further changes.
> 
> So is that an ack for putting this in scsi-misc ... or did you want to
> do more testing first?

Ping,

Brian, James, can we merge this during the next merge window?


