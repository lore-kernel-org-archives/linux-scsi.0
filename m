From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Date: Thu, 25 Sep 2008 18:06:00 -0700
Message-ID: <200809260106.m8Q160kj028501@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:19760 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYIZBGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 21:06:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains document of brocade specific sysfs interface.
It is created using 2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 Documentation/ABI/testing/sysfs-devices-bfa |  600 ++++++++++++++++++++++++++++
 1 files changed, 600 insertions(+)

diff -urpN orig/Documentation/ABI/testing/sysfs-devices-bfa patch/Documentation/ABI/testing/sysfs-devices-bfa
--- orig/Documentation/ABI/testing/sysfs-devices-bfa	1969-12-31 16:00:00.000000000 -0800
+++ patch/Documentation/ABI/testing/sysfs-devices-bfa	2008-09-24 12:08:25.000000000 -0700
@@ -0,0 +1,600 @@
+What:		/sys/devices/<Brocade HBA PCI path>/bfa
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:
+		The /sys/devices/<Brocade HBA device path>/bfa will contain
+		files and subdirectories to display internal states and
+		statistics of Brocade HBA. It also provides a configuration and
+		management interface for each HBA instance.
+
+What:		/sys/devices/<Brocade HBA PCI path>/bfa/ioc
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:
+		The /sys/devices/<Brocade HBA device path>/ioc will contain
+		files and directories to display ioc level attributes
+		and statistics of the HBA.
+
+Files and directories under /sys/devices/<Brocade HBA PCI path>/bfa/ioc:
+------------------------------------------------------------------------
+
+bios_ver
+
+	 BIOS version
+
+chip_rev		
+
+	Chip version
+
+fw_ver
+	Firmware version
+
+hw_name
+
+	Hardware name or pci path
+
+hw_ver
+
+	Hardware version
+
+intr
+	Interrupt coalescing setting 
+
+manufacturer
+
+	Manufacturer info
+
+model_desc
+	
+	Model description
+
+mpiomode
+
+	mpio mode setting of IOC
+
+name
+	Name of the driver
+
+nwwn
+	World Wide Node Name
+
+optrom_ver
+
+	Option Rom version
+
+port_count
+
+	Port count of the HBA
+
+power
+
+	IOC power state
+
+pwwn
+
+	World Wide Node Name
+
+serial_num
+
+	Serial number
+
+statistics/
+	
+	Contains following files for IOC level statistics:
+
+	disable_replies
+		
+		Number of IOC disable replies
+
+	disable_requests
+
+		Number of IOC disable requests
+
+	enable_replies
+
+		Number of IOC Enable replies
+
+	enable_requests
+
+		Number of IOC Enable requests
+
+	heartbeat_count
+
+		Number of heartbeat count 
+
+	reset
+
+		Write to reset the IOC statistics.
+
+
+What:		/sys/devices/<Brocade HBA PCI path>/bfa/pport
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:
+		The /sys/devices/<Brocade HBA device path>/pport will contain
+		files and directories to display pport (physical port) level
+		attributes and statistics of the HBA.
+
+Files and directories under /sys/devices/<Brocade HBA PCI path>/bfa/pport:
+--------------------------------------------------------------------------
+
+enable
+
+	Eenable/disable the pport.
+
+maxfrmi
+ 	Maximum frame size
+	
+media	 	
+	SFP 
+
+nwwn
+	
+	World wide node name
+
+port_id
+
+	Fibre Channel port ID
+
+port_type
+
+	Port type
+
+pwwn
+
+	World wide port name
+
+recv_bb_credits
+
+	Receive buffer credits
+
+speed_config
+
+	Configured port speed.
+
+speed_current
+
+	Current port speed
+
+state
+
+	Port state 
+	
+supported_classes
+
+	Supported classes of services
+
+symbolic_name
+
+	Symbolic name of the pport
+
+topology_config
+
+	Configured topology
+
+topology_current
+
+	Current topology
+
+statistics/
+
+	Contains following files for pport level statistic:
+
+	dropped_frames
+
+		Number of frames that were lost due to lack of host buffers
+		available
+
+	error_frames
+		
+		Number of frames that have been received in error
+
+	invalid_crcs
+
+		Number of frames that received with invalid CRC
+
+	invalid_ordered_set
+		
+		Number of invalid ordered that have received
+		
+	link_failures
+
+		Number of times that a link error has occurred
+
+	lip_count
+
+		Number of LIP events that have occurred.
+
+	loss_of_signals
+
+		Number of times loss of signal has occurred
+	
+	loss_of_syncs
+
+		Number of times loss of sync has occurred
+
+	nos_count
+
+		Number of NOS events that have occurred on the switched fabric
+
+	primitive_seq_errs
+
+		Number of primitive sequence protocol errors
+
+	rx_frames
+
+		Number of total received Fibre Channle frames across all
+		protocols and classes
+
+	rx_words
+
+		Number of total received Fibre Channle words across all
+		protocols and classes
+
+	secs_since_reset
+
+		Number of seconds since the statistics were last reset
+
+	tx_frames
+
+		Number of total transmitted Fibre Channle frames across all
+		protocols and classes
+
+	tx_words
+	
+		Number of total transmitted Fibre Channle words across all
+		protocols and classes
+	
+	reset
+
+		Write to reset the pport statistics
+
+
+What:		/sys/devices/<Brocade HBA PCI path>/bfa/lport
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:	
+		The /sys/devices/<Brocade HBA device path>/lport will contain
+		files and directories to display lport (logical port) level
+		attributes and statistics of the HBA.
+
+Files and directories under /sys/devices/<Brocade HBA PCI path>/bfa/lport:
+--------------------------------------------------------------------------
+
+nwwn
+	
+	World wide node name 
+
+port_id
+
+	Fibre Channel port ID
+
+pwwn
+
+	World wide port name
+
+refresh_rports
+
+	Read to this file will show number of remote port (rport) connected to
+	the logical port, and will also creat a rp-<wwpn> directory for each 
+	rport.
+
+role
+
+	Role of the lport
+
+state
+
+	State of the lport
+
+symbolic_name
+
+	Symbolic name of the lport
+
+type
+
+	lport type
+
+statistics/
+
+	Contains following files for lport level statistics:
+
+	ns_gidft_accepts
+
+		Number of GID_FT requests that have been accepted by the name
+		server
+
+	ns_gidft_alloc_wait
+
+		Number of GID_FT requests that have fcxp allocation failure
+		and been put in the wait queue. 
+
+	ns_gidft_rejects
+
+		Number of GID_FT requests that have been rejected by the name
+		server
+
+	ns_gidft_rsp_err
+
+		Number of GID_FT requests that have completed with response
+		error 
+
+	ns_gidft_sent
+
+		Number of GID_FT requests that have been sent 
+
+	ns_gidft_unknown_rsp
+
+		Number of GID_FT requests that have completed with unknown 
+		response code
+
+	ns_plogi_accepts
+
+		Number of PLOGI requests that have been accepted by the name
+		server
+
+	ns_plogi_acc_err
+
+		Number of PLOGI requests that have been accepted by the name
+		server but with wrong response length
+
+	ns_plogi_alloc_wait
+
+		Number of PLOGI  requests that have fcxp allocation failure
+		and been put in the wait queue. 
+
+	ns_plogi_rejects
+
+		Number of PLOGI requests that have been rejected by the name
+		server
+
+	ns_plogi_rsp_err
+
+		Number of PLOGI requests that have completed with response
+		error 
+
+	ns_plogi_sent
+
+		Number of name server PLOGI requests that have been sent 
+
+	ns_plogi_unknown_rsp
+
+		Number of plogi requests that have completed with unknown 
+		response code
+
+	ns_retries
+		
+		Number of name server command retries
+
+	ns_rftid_accepts
+
+		Number of RFT_ID requests that have been accepted by the name
+		server
+
+	ns_rftid_alloc_wait
+
+		Number of RFT_ID requests that have fcxp allocation failure
+                and been put in the wait queue
+
+	ns_rftid_rejects
+
+		Number of RFT_ID requests that have been rejected by the name
+                server
+
+	ns_rftid_rsp_err
+
+		Number of RFT_ID requests that have completed with response
+                error
+
+	ns_rftid_sent
+
+		Number of RFT_ID requests that have been sent
+
+	ns_rspnid_accepts
+
+		Number of RSPN_ID requests that have been accepted by the name
+		server
+
+	ns_rspnid_alloc_wait
+		Number of RSPN_ID requests that have fcxp allocation failure
+		and been put in the wait queue.
+
+	ns_rspnid_rejects
+
+		Number of RSPN_ID requests that have been rejected by the name
+                server
+
+	ns_rspnid_rsp_err
+
+		Number of RSPN_ID requests that have completed with response
+                error
+		
+	ns_rspnid_sent
+
+		Number of RSPN_ID requests that have been sent
+
+	ns_timeouts
+
+		Number of name server command timeouts
+
+	num_portid_rscn
+
+		Number of Port ID RSCN received
+
+	num_rscn
+
+		Number of RSCN received
+
+	reset
+
+		Write to reset lport statistics
+
+
+What:		/sys/devices/<Brocade HBA PCI path>/bfa/lport/rp-<pwwn>
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:	
+		The /sys/devices/<Brocade HBA device path>/lport/rp-<pwwn>
+		will contain files and directories to display attributes and
+		statistics of a rport (remote port, identified by its world
+		wide port name) of lport. 
+
+Files and directories under /sys/devices/<...>/bfa/lport/rp-<pwwn>:
+-------------------------------------------------------------------
+
+cisc
+	CISC capable device
+
+class_of_service
+
+	Fibre Channel classes of services
+
+data_field_size
+
+	Maximum payload size
+
+nwwn
+	
+	Rport world wide node name
+
+port_id
+
+	Rport FC port ID
+
+pwwn
+
+	Rport world wide port name
+
+qos_priority
+
+	Rport Qos priority
+
+speed
+
+	Rport speed
+
+state
+
+	Rport state
+
+symbolic_name
+
+	Rport symbolic name
+
+statistics/
+
+	Contains following files for rport statistics:
+
+	logo_accepts
+
+		Number LOGO accepts from the rport
+
+	logo_sent
+		
+		Number of LOGOs sent to the rport 
+
+	offlines
+
+		Number of rport offlines
+
+	onlines
+
+		Number of rport onlines
+
+	plogi_accepts
+
+		Number of PLOGI accepts from the rport
+
+	plogi_failed
+
+		Number of PLOGI failures to the rport 
+
+	plogi_rcvd
+
+		Number of PLOGIs received from rport
+
+	plogi_rejects
+
+		Number of PLOGI rejects from the rport
+
+	plogi_sent
+
+		Number of PLOGIs sent to the rport. 
+
+	plogi_timeouts
+
+		Number of PLOGI timeouts to the rport. 
+
+	prli_rcvd
+
+		Number of PRLIs received from the rport. 
+
+	rscns
+
+		Number of RSCNs that affect the rport
+
+	reset
+		
+		Write to reset rport statistics
+
+
+What:		/sys/devices/<Brocade HBA PCI path>/bfa/lport/rp-<pwwn>/itnim
+Date:		July 2008
+Contact:	Jing Huang <huangj@brocade.com>
+Description:	
+		The /sys/devices/<Brocade HBA device path>/lport/rp-<pwwn>
+		/itnim will contain files and directories to display attributes
+		and statistics of an itnim (initiator and target nexus) associated
+		with a rport.
+
+Files and directories under /sys/devices/<...>/bfa/lport/rp-<pwwn>/itnim:
+-------------------------------------------------------------------------
+
+state
+
+	itnim state
+
+statistics/
+
+	Contains following files for itnim statistics:
+
+	fcxp_alloc_wait
+
+		Number of PRLI requests that have failed fcxp allocation failure
+		and been put in the wait queue.
+
+	initiator_mode
+
+		Is the rport in initiator mode
+
+	offlines
+
+		Number of offlines
+
+	onlines
+
+		Number of onlines
+
+	prli_rsp_acc
+
+		Number of PRLI accepts
+
+	prli_rsp_err
+
+		Number of PRLI failures
+
+	prli_rsp_parse_err
+
+		Number of PRLI response with parse error
+
+	prli_sent
+		
+		Number of PRLI sent to the itnim
+
+	second_level_error_recovery
+
+		Number of second level error recovery notifications
+
+	reset
+
+		Write to reset itnim statistics
