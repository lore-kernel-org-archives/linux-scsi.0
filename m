From: "Ranade, Prakash" <prakashr@intgroup.com>
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 11:23:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7F2171947E956F4ABE17D12CA19617B405EE56@intermarksrv001.intermark.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.intgroup.com ([65.83.52.2]:60782 "HELO
	intermarksrv001.intermark.local") by vger.kernel.org with SMTP
	id S263264AbTFTQJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2003 12:09:34 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-scsi@vger.kernel.org

well i did change it to 14 and 15...but it seems that there is a conflict between 2 nodes on using same scsi drive. The interfaces are fighting over the bus.. They both kept resetting the drive.
any idea......
Prakash S. Ranade
OCP - Oracle Certified DBA 8i, 9i
205 776 2320

"Lets document it and call it a feature"


-----Original Message-----
From: Mike Dresser [mailto:mdresser_l@windsormachine.com]
Sent: Friday, June 20, 2003 11:04 AM
To: Ranade, Prakash
Cc: linux-scsi@vger.kernel.org
Subject: Re: how to connect 2 nodes to a SCSI disk (cabinet)


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

