From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 18:11:23 +0900
Message-ID: <20110214181129X.fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34430 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1BNJLc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 04:11:32 -0500
In-Reply-To: <AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, nab@linux-iscsi.org

On Mon, 14 Feb 2011 08:16:45 +0100
Bart Van Assche <bvanassche@acm.org> wrote:

> Are you sure that it is fine to pass values like MSG_SIMPLE_TAG as the
> sixth argument of transport_init_se_cmd() ? As far as I know TCM
> doesn' t support any of the MSG_..._TAG values.

Oops, I'll send the next version soon.
