From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [RFC] zfcp: add statistics and other zfcp related information to sysfs
Date: Wed, 5 Sep 2007 12:33:11 +0200
Message-ID: <200709051233.11335.swen@vnet.ibm.com>
References: <200709031416.21901.swen@vnet.ibm.com> <20070903124059.GP14130@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64545 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbXIEKaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2007 06:30:21 -0400
In-Reply-To: <20070903124059.GP14130@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org

On Monday 03 September 2007 14:40, Matthew Wilcox wrote:
> On Mon, Sep 03, 2007 at 02:16:21PM +0200, Swen Schillig wrote:
> > /sys/bus/ccw/drivers/zfcp/0.0.1707 
> > /* information for the virtual adapter */
> > 	statistic_services/ 	
> > 		requests	
> > 		megabytes
> > 		utilization
> > 		seconds_active
> > /* LUN specific info for channel- and fabric-latency */
> > 	0x500507630300c562/0x401040a600000000/  
> > 		read_latency
> > 		write_latency
> > 		cmd_latency
> > 
> > Please comment if this would be an acceptable way to publish 
> > the additional information.
> 
> This seems like it might be information that other adapters could,
> in theory, also provide.  Maybe the first set of stats should
> be added to /sys/class/scsi_host/hostN/ and the second set to
> /sys/class/scsi_device/H:C:T:L/ ?  The names of the individual files
> make sense to me.
> 

Matthew, thanks for your feedback. 
In the past we were trying a centralized and common approach a couple of times,
with no success.
Since we really need to have our data available soon, 
I'd prefer to start off with the "proprietary" location and make this data available 
to our customers.

Anybody else some comments ?
Otherwise I'll post the patch.

Cheers Swen
