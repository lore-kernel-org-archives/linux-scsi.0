From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 12:56:33 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306201256090.838-100000@router.windsormachine.com>
References: <7F2171947E956F4ABE17D12CA19617B40279BE@intermarksrv001.intermark.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from windsormachine.com ([206.48.122.28]:46090 "EHLO
	router.windsormachine.com") by vger.kernel.org with ESMTP
	id S263355AbTFTQmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 12:42:35 -0400
In-Reply-To: <7F2171947E956F4ABE17D12CA19617B40279BE@intermarksrv001.intermark.local>
List-Id: linux-scsi@vger.kernel.org
To: "Ranade, Prakash" <prakashr@intgroup.com>
Cc: linux-scsi@vger.kernel.org



On Fri, 20 Jun 2003, Ranade, Prakash wrote:

> node1 and node2 both running redhat linux 7.2...both have Adaptec scsi card in it...scsi disk is  DataSilo DS-100 (see attached manual) using Seagate HD.
> node1:scsi id = 14 - scsi termination is disabled
> node1:scsi id = 15 - scsi termination is automatic (i tried all enabled/disabled/automatic nothing works)
> external scsi disk id = 0
>
> node 1 							node 2
> 	|							|
> 	|							|
> 	---------external SCSI drive---------------
>

Any internal connections on either SCSI card?

If not, set both node's to enabled scsi termination.

Mike

