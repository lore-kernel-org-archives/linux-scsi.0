From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Fri, 14 May 2010 18:29:55 +0900
Message-ID: <20100514183051S.fujita.tomonori@lab.ntt.co.jp>
References: <1273671164.24670.21.camel@wookie>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41383 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0ENJaG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2010 05:30:06 -0400
In-Reply-To: <1273671164.24670.21.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Wed, 12 May 2010 09:32:14 -0400
James Smart <james.smart@emulex.com> wrote:

> - Add reference counting to prevent module removal when
>   there are outstanding BSG requests.

Didn't I worked on it about scsi_transport_sas?

bsg holds the ref count on the device that passed in
bsg_register_queue() while there are outstanding bsg requests. It is
supposed to prevent the module of the hold device from be removed.

Do you get the oops message?
