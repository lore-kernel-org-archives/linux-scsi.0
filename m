From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 10:42:55 +0900
Message-ID: <20110214104254R.fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4D543951.2000207@linux.vnet.ibm.com>
	<1297366739.18212.182.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33677 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1BNBnB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2011 20:43:01 -0500
In-Reply-To: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: brking@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Thu, 10 Feb 2011 11:38:59 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Also, we are able to explictly limit individual struct se_device
> backends to disable PR and only use the older SCSI-2 reservations, but I
> don't think we have a way to do this on a fabric module wide basis just
> yet.

As I wrote in another mail, multiple initiators don't connect to the
same target.
