From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [Qemu-devel] Testing NPIV Feature with Qemu-KVM
Date: Thu, 5 Sep 2013 14:55:37 +0000
Message-ID: <A4BC99A5F8245F4CBCD582D057D75DAF625B7952@ORSMSX106.amr.corp.intel.com>
References: <20130902123444.GA25765@oc2505588478.ibm.com>
 <CAJSP0QUEPjqti5ZuJGZs-9o4yXSQWebVJ1O8HMAbf6iv+9FdGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3IEOzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 10:55:38 -0400
In-Reply-To: <CAJSP0QUEPjqti5ZuJGZs-9o4yXSQWebVJ1O8HMAbf6iv+9FdGw@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>, chandrashekar shastri <cshastri@oc2505588478.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

<snip>

> > How do I make sure that qemu is using the virtual HBA or (vport)?
> 
> From my limited knowledge of NPIV, after you create the vport on the host
> you'll have a new "SCSI host" which scans LUNs.  That means new SCSI
> devices appear on the host.
> 
> You can use "ls -al /sys/class/scsi_host" to see the SCSI hosts that are active.
> 

Also, there will be a /sys/class/fc_host, associated with the scsi_host. It will have a port_type, that when read, should show "NPIV VPORT".

//Rob
