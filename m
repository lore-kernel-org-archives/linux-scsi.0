From: "Ranade, Prakash" <prakashr@intgroup.com>
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 12:01:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7F2171947E956F4ABE17D12CA19617B40279C0@intermarksrv001.intermark.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.intgroup.com ([65.83.52.2]:12164 "HELO
	intermarksrv001.intermark.local") by vger.kernel.org with SMTP
	id S263398AbTFTQrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2003 12:47:03 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-scsi@vger.kernel.org

isent it true that...
you cannot have two seperate SCSI controllers trying to maintain the same bus.They will fight..for same bus?

Prakash S. Ranade
OCP - Oracle Certified DBA 8i, 9i
205 776 2320

"Lets document it and call it a feature"


-----Original Message-----
From: Mike Dresser [mailto:mdresser_l@windsormachine.com]
Sent: Friday, June 20, 2003 11:57 AM
To: Ranade, Prakash
Cc: linux-scsi@vger.kernel.org
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)




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

