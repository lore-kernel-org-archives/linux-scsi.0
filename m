From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 13:09:24 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306201308130.838-100000@router.windsormachine.com>
References: <7F2171947E956F4ABE17D12CA19617B40279C0@intermarksrv001.intermark.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from windsormachine.com ([206.48.122.28]:19211 "EHLO
	router.windsormachine.com") by vger.kernel.org with ESMTP
	id S263528AbTFTQz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 12:55:28 -0400
In-Reply-To: <7F2171947E956F4ABE17D12CA19617B40279C0@intermarksrv001.intermark.local>
List-Id: linux-scsi@vger.kernel.org
To: "Ranade, Prakash" <prakashr@intgroup.com>
Cc: linux-scsi@vger.kernel.org



On Fri, 20 Jun 2003, Ranade, Prakash wrote:

> isent it true that...
> you cannot have two seperate SCSI controllers trying to maintain the same bus.They will fight..for same bus?

You can have multiple controllers on the same bus.

As for the termination question, you only terminate at the ends.  So if
you have  Card - Storage - Card, you need to set the termination to
enabled on both cards.

If you had InternalDrive - Card - Storage - Card, you'd set the
termination on the internaldrive(which would normally be done with the
cableing there), and then on the Card on the other end, but the first card
would not have termination set at all.

Mike

