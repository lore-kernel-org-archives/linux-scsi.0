From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 12:03:32 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306201202130.15589-100000@router.windsormachine.com>
References: <7F2171947E956F4ABE17D12CA19617B40279BA@intermarksrv001.intermark.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from windsormachine.com ([206.48.122.28]:28424 "EHLO
	router.windsormachine.com") by vger.kernel.org with ESMTP
	id S263187AbTFTPvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 11:51:04 -0400
In-Reply-To: <7F2171947E956F4ABE17D12CA19617B40279BA@intermarksrv001.intermark.local>
List-Id: linux-scsi@vger.kernel.org
To: "Ranade, Prakash" <prakashr@intgroup.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 20 Jun 2003, Ranade, Prakash wrote:

> we have 2 servers running redhat linux and a external SCSI disk
> (cabinet). we want to connect this scsi disk to 2 servers we have for
> oracle parallel server installation i tried connecting both of them
> simultaneously to the scsi but it fails ....I can connect only one at
> a time .....anyone used it like this for Oracle Parallel Server ....
>
> Let me know if you need anymore info

I assume you're handing filesystem contention somehow.

But anyways, check that you've changed the SCSI ID on a controller to
something besides 7.  The default SCSI ID on a controller is 7, and if
you have the two of them on that, they will conflict.

Mike

