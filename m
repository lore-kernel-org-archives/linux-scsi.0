From: James.Smart@Emulex.Com
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 13:20:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F234@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20726 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261345AbUJZRVW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 13:21:22 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com, hch@infradead.org, jeremy@sgi.com
Cc: linux-scsi@vger.kernel.org

> The failures to compiled in 2.6.10-rc is due to someone changing
> the defines in scsi_transport_fc.h.
> 
> 2.6.9				2.6.10-rc				
> ---------			---------
> fc_port_id			fc_starget_port_id
> fc_node_name		fc_starget_node_name
> fc_port_name		fc_starget_port_name

Then you haven't been paying attention to linux-scsi. As part of Emulex's desire to move upstream, and commonize FC information, the transport got corrected so that the 3 attributes are target based rather than sdev based. See the following patch (http://marc.theaimsgroup.com/?l=linux-scsi&m=109663907926965&w=2). This became part of 2.6.9-bk1/2.6.10-rc. Also - I've proposed more attributes to the host to better align with FC HBAAPI management infrastructures - see the following patches: http://marc.theaimsgroup.com/?l=linux-scsi&m=109776541400698&w=2; http://marc.theaimsgroup.com/?l=linux-scsi&m=109776541525816&w=2; http://marc.theaimsgroup.com/?l=linux-scsi&m=109813309907129&w=2.

There are still more attributes coming, as the target/remote port attributes get expanded. Now that I know you're support the FC transport, I'll involve you in the discussions.

-- James
