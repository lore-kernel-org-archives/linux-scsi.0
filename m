From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch RFC] Add FC transport host attributes
Date: Thu, 14 Oct 2004 19:38:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014183814.GA12264@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C0866D0@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:3590 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267294AbUJNSiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 14:38:18 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C0866D0@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu

On Thu, Oct 14, 2004 at 10:52:52AM -0400, James.Smart@Emulex.Com wrote:
> 
> This patch updates the fc_transport with attributes for local FC ports
> (e.g. Hosts).  The port attributes are defined per HBAAPI v2.0 definitions.
> 
> Caveats:
> ------------
> - This patch applies to the scsi-target-2.6 bitkeeper tree. It is dependent
>   upon the previous "host statistics" and "fc statistics" patches.
> 
> - This does not address remote port (target) information. This will be in
>   a subsequent patch.
> 
> - The information below is supplied by a simple test driver that does not
>   talk to real hardware, but fully acts as a LLDD that supports the
>   fc transport.
> 
> 
> This patch results in the following in /sys/class:
> -----------------------------------------------------
> 
> [jsmart@elxware class]$ cd /sys/class
> [jsmart@elxware class]$ ls
> fc_host       graphics  misc     pci_bus       scsi_host  usb_host
> fc_transport  input     net      scsi_device   tty        vc
> firmware      mem       netlink  scsi_generic  usb
> [jsmart@elxware class]$ cd fc_host
> [jsmart@elxware fc_host]$ ls
> host4
> 
> [jsmart@elxware fc_host]$ cd host4
> [jsmart@elxware host4]$ ls
> device                 host_port_maxframe_size      host_port_supported_speeds
> host_fabric_name       host_port_name               host_port_symbolic_name
> host_link_down_tmo     host_port_speed              host_port_type
> host_node_name         host_port_state              host_tgtid_bind_type
> host_port_active_fc4s  host_port_supported_classes  statistics
> host_port_id           host_port_supported_fc4s

Any chance you can kill all those host_port prefixes?
