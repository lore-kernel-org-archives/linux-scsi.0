From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Proposal to add sysfs attributes for FCoE in FC Transport layer
Date: Tue, 31 Mar 2009 18:06:23 -0700
Message-ID: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54211 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761548AbZDABG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 21:06:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Hi SCSI mailing list,

	I'd like to propose following additions to sysfs to export statistics  
of FCoE host bus adapters.
The additions can be broadly divided into capabilities of FCoE HBA  
adapter and its statistics.
I am thinking of extending HBA specific informations inside the  
fc_host(/sys/class/fc_host/hostX) and make a seperate
attribute_group(/sys/class/fc_host/hostx/fcoe_statistics/) for fcoe  
statistics.

FCoE HBA specific information

1) enode_mac_address		/* Factory programmed MAC address */
2) vn_port_mac_address;     	/* Current programmed MAC address */
3) fcf_mac_address;			/* FCF mac address */
4) vlan_id:					/* Local VLAN ID */
5) mac_addressing_model	/* Whether SPMA or FPMA */

Current DCBX parameter details:

PGID (Priority group ID)

1) pgid_priority_group_0;       /* Priority group ID of priority group  
0 */
2) pgid_priority_group_1;       /* Priority group ID of priority group  
1 */
3) pgid_priority_group_2;       /* Priority group ID of priority group  
2 */
4) pgid_priority_group_3;       /* Priority group ID of priority group  
3 */
5) pgid_priority_group_4;       /* Priority group ID of priority group  
4 */
6) pgid_priority_group_5;       /* Priority group ID of priority group  
5 */
7) pgid_priority_group_6;       /* Priority group ID of priority group  
6 */
8) pgid_priority_group_7;       /* Priority group ID of priority group  
7 */

Bandwidth assignment per priority group

1) priority_group_0_bw_percentage; 	/* Priority group 0 bandwidth  
percentage */
2) priority_group_1_bw_percentage; 	/* Priority group 1 bandwidth  
percentage */
3) priority_group_2_bw_percentage; 	/* Priority group 2 bandwidth  
percentage */
4) priority_group_3_bw_percentage; 	/* Priority group 3 bandwidth  
percentage */
5) priority_group_4_bw_percentage; 	/* Priority group 4 bandwidth  
percentage */
6) priority_group_5_bw_percentage; 	/* Priority group 5 bandwidth  
percentage */
7) priority_group_6_bw_percentage; 	/* Priority group 6 bandwidth  
percentage */
8) priority_group_7_bw_percentage; 	/* Priority group 7 bandwidth  
percentage */

Priority based flow control (PFC)

1) pfc_enabled_priority_0		/* Flow control is enabled in both  
direction for priority 0 */
2) pfc_enabled_priority_2		/* Flow control is enabled in both  
direction for priority 1 */
3) pfc_enabled_priority_3		/* Flow control is enabled in both  
direction for priority 2 */
4) pfc_enabled_priority_4		/* Flow control is enabled in both  
direction for priority 3 */
5) pfc_enabled_priority_5		/* Flow control is enabled in both  
direction for priority 4 */
6) pfc_enabled_priority_6		/* Flow control is enabled in both  
direction for priority 5 */
7) pfc_enabled_priority_7		/* Flow control is enabled in both  
direction for priority 6 */
8) pfc_enabled_priority_8		/* Flow control is enabled in both  
direction for priority 7 */

Statistics:

1) fcoe_tx_frames;               		/* number of FCoE transmit frames */
2) fcoe_tx_words;				/* number of tx words */	
3) fcoe_rx_frames;                		/* number of FCoE receive frames */
4) fcoe_rx_words;				/* number of rx words */	
5) fcoe_rx_drop_frames;                	/* number of FCoE dropped  
receive frames */
6) fcoe_tx_pause_pkts;                 	/* number of FCoE transmit  
PAUSE packets */
7) fcoe_rx_pause_pkts;                 	/* number of FCoE receive  
PAUSE packets */
8) fcoe_tx_cbfc_pause_frames_0;        	/* number of class based flow  
control transmit PAUSE frames on PG 0 */
9) fcoe_tx_cbfc_pause_frames_1;        	/* number of class based flow  
control transmit PAUSE frames on PG 1 */
10) fcoe_tx_cbfc_pause_frames_2;       	/* number of class based flow  
control transmit PAUSE frames on PG 2 */
11) fcoe_tx_cbfc_pause_frames_3;       	/* number of class based flow  
control transmit PAUSE frames on PG 3 */
12) fcoe_tx_cbfc_pause_frames_4;       	/* number of class based flow  
control transmit PAUSE frames on PG 4 */
13) fcoe_tx_cbfc_pause_frames_5;       	/* number of class based flow  
control transmit PAUSE frames on PG 5 */
14) fcoe_tx_cbfc_pause_frames_6;       	/* number of class based flow  
control transmit PAUSE frames on PG 6 */
15) fcoe_tx_cbfc_pause_frames_7;       	/* number of class based flow  
control transmit PAUSE frames on PG 7 */
16) fcoe_rx_cbfc_pause_frames_0;       	/* number of class based flow  
control recieve PAUSE frames on PG 0 */
17) fcoe_rx_cbfc_pause_frames_1;       	/* number of class based flow  
control recieve PAUSE frames on PG 1 */
18) fcoe_rx_cbfc_pause_frames_2;       	/* number of class based flow  
control recieve PAUSE frames on PG 2 */
19) fcoe_rx_cbfc_pause_frames_3;       	/* number of class based flow  
control recieve PAUSE frames on PG 3 */
20) fcoe_rx_cbfc_pause_frames_4;       	/* number of class based flow  
control recieve PAUSE frames on PG 4 */
21) fcoe_rx_cbfc_pause_frames_5;       	/* number of class based flow  
control recieve PAUSE frames on PG 5 */
22) fcoe_rx_cbfc_pause_frames_6;       	/* number of class based flow  
control recieve PAUSE frames on PG 6 */
23) fcoe_rx_cbfc_pause_frames_7;       	/* number of class based flow  
control recieve PAUSE frames on PG 7 */
24) fcoe_tx_priority_pkts_0;            		/* number of priority 0  
based transmit packets */
25) fcoe_tx_priority_pkts_1;            		/* number of priority 1  
based transmit packets */
26) fcoe_tx_priority_pkts_2;            		/* number of priority 2  
based transmit packets */
27) fcoe_tx_priority_pkts_3;            		/* number of priority 3  
based transmit packets */
28) fcoe_tx_priority_pkts_4;            		/* number of priority 4  
based transmit packets */
29) fcoe_tx_priority_pkts_5;           		/* number of priority 5 based  
transmit packets */
30) fcoe_tx_priority_pkts_6;            		/* number of priority 6  
based transmit packets */
31) fcoe_tx_priority_pkts_7;            		/* number of priority 7  
based transmit packets */
32) fcoe_rx_priority_pkts_0;            		/* number of priority 0  
based received packets */
33) fcoe_rx_priority_pkts_1;            		/* number of priority 1  
based received packets */
34) fcoe_rx_priority_pkts_2;            		/* number of priority 2  
based received packets */
35) fcoe_rx_priority_pkts_3;            		/* number of priority 3  
based received packets */
36) fcoe_rx_priority_pkts_4;            		/* number of priority 4  
based received packets */
37) fcoe_rx_priority_pkts_5;            		/* number of priority 5  
based received packets */
38) fcoe_rx_priority_pkts_6;            		/* number of priority 6  
based received packets */
39) fcoe_rx_priority_pkts_7;            		/* number of priority 7  
based received packets */

Thanks,
Giridhar Malavali

