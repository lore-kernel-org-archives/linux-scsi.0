From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take
 2
Date: Thu, 09 Sep 2004 10:40:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413FA664.6050009@torque.net>
References: <20040907210520.0251476C56@isis.visi.com>	<413E6F8F.3020008@torque.net> <20040908073843.7dbcddb6.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:17134 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269247AbUIIAlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 20:41:04 -0400
In-Reply-To: <20040908073843.7dbcddb6.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: sferris@acm.org, James.Bottomley@SteelEye.com, mikenc@us.ibm.com, michaelc@cs.wisc.edu, willy@debian.org, hch@lst.de, surekhap@cisco.com, linux-scsi@vger.kernel.org

Randy.Dunlap wrote:
> On Wed, 08 Sep 2004 12:33:51 +1000 Douglas Gilbert wrote:
> 
> | Scott M. Ferris wrote:
> | <snip>
> | > 
> | > Should all drivers that currently use one host for each SCSI initiator
> | > device, and a channel for each initiator port on each device, be
> | > modified to use a host for each initiator port?
> | > 
> | > Documentation/scsi/scsi_mid_low_api.txt says that a host corresponds
> | > to a SCSI initiator device.  Could someone change that to say SCSI
> | > initiator port instead, since that seems to be the new goal?
> | 
> | Scott,
> | Yes, I can change that if we all agree. Randy Dunlap asked me some
> | time back to define what was meant by a "linux SCSI host" and that
> | was the best I could come up with at the time.
> 
> Sorry to be dense here, but what is an "initiator port" in this context?
> Is it a physical connector or something else?  A logical connector?
> (whatever that means)

Probably the best place to start is the diagram at
http://www.t10.org under the "Architecture" tab near the
top of the left hand pane. The focus of that diagram is
the Architectural Model (SAM) of which
http://www.t10.org/ftp/t10/drafts/sam3/sam3r13.pdf
is the latest available draft. The transports are
along the bottom of that diagram and the command sets
are along the top.

The concepts of initiator, target, port and delivery
subsystems are defined (abstractly) in SAM-3.
It then falls to the various transports (e.g. FCP,
iSCSI and SPI) to put "meat" on these abstractions
and add some of their own terms (e.g. "logical connector"
from iSCSI). Transports that are not exclusively used
by SCSI command sets (e.g. iSCSI uses IP) come with
their own architectural models and jargon.

SCSI has been around for over 20 years (see wikipedia.org)
and for the first 15 years was synonymous with the "SCSI Parallel
Interface" (SPI) but that is no longer the case. That
change has been very slow getting out to the wider technical
community (as reflected by the SCSI entry in wikipedia.org)

<snip/>

> | 
> | A few related matters:
> | 
> | Steven Fairchild dropped a proposal for SAS storage management
> 
> "dropped" as in dropped (oh, as in deleted) or as in "added", "put",
> or "placed" ?  Seems to be "added"...

Sorry, just sloppy usage. Authors put proposals on that site
for comment.

Doug Gilbert

