From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] zfcp: add statistics and other zfcp related information to sysfs
Date: Mon, 3 Sep 2007 06:40:59 -0600
Message-ID: <20070903124059.GP14130@parisc-linux.org>
References: <200709031416.21901.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46253 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXICMlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Sep 2007 08:41:04 -0400
Content-Disposition: inline
In-Reply-To: <200709031416.21901.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 03, 2007 at 02:16:21PM +0200, Swen Schillig wrote:
> /sys/bus/ccw/drivers/zfcp/0.0.1707 
> /* information for the virtual adapter */
> 	statistic_services/ 	
> 		requests	
> 		megabytes
> 		utilization
> 		seconds_active
> /* LUN specific info for channel- and fabric-latency */
> 	0x500507630300c562/0x401040a600000000/  
> 		read_latency
> 		write_latency
> 		cmd_latency
> 
> Please comment if this would be an acceptable way to publish 
> the additional information.

This seems like it might be information that other adapters could,
in theory, also provide.  Maybe the first set of stats should
be added to /sys/class/scsi_host/hostN/ and the second set to
/sys/class/scsi_device/H:C:T:L/ ?  The names of the individual files
make sense to me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
