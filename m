From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] multipath-tools-0.3.4
Date: Mon, 25 Oct 2004 10:22:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098692559.2798.7.camel@laptop.fenrus.org>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:34054 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261717AbUJYIW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 04:22:58 -0400
In-Reply-To: <1098656088.9350.88.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2004-10-25 at 00:14 +0200, christophe varoqui wrote:

> 	* multipath & multipathd now use the same path checkers.
> 	  Consequence being multipath now need sg loaded

why sg and not using SG_IO on the actual devices ?
mp-tools are 2.6 only anyway, right ?
-- 

