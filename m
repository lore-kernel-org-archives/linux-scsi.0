From: Krishna Gudipati <gudipati@usc.edu>
Subject: Creating a subdirectory under fc_host statistics using
 fc_function_template
Date: Wed, 10 Dec 2008 11:39:33 -0800
Message-ID: <ddedcbc75baf.493faa75@usc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from msg-scanner2.usc.edu ([128.125.137.211]:51334 "EHLO
	msg-scanner2.usc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYLJTjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 14:39:35 -0500
Received: from msg-store3.usc.edu ([128.125.137.14])
 by msg-scanner0.usc.edu (Sun Java System Messaging Server 6.2-3.04 (built Jul
 15 2005)) with ESMTP id <0KBO00HCEELYF150@msg-scanner0.usc.edu> for
 linux-scsi@vger.kernel.org; Wed, 10 Dec 2008 11:39:34 -0800 (PST)
Received: from usc.edu (localhost [127.0.0.1])
 by msg-store3.usc.edu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0KBO00HWQELX1B50@msg-store3.usc.edu> for
 linux-scsi@vger.kernel.org; Wed, 10 Dec 2008 11:39:34 -0800 (PST)
Content-language: en
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Hello Everyone,

I have a small question on how to create a sub-directory to store my driver specific data under fc_host statistics.

Currently i am using the fc_function_template's  .get_fc_host_stats to export all my fc_host statistics. 

But now i need a way to create a directory under the /sys/class/fc_host/statistics 

lets say /sys/class/fc_host/statistics/hba/ns_stats to store all the specific information regarding name_server or 
this type of information for different stats we want to collect. Basically we are thinking of having a hierarchy 
under the fc_host/statistics folder so that we can display our driver specific information in a much cleaner fashion.

I researched looking at the current "struct fc_function_template" under scsi_transport_fc.c but did not find a way where i can specify 
that i need to create a folder under this statistics folder. I am not aware as of now if this feature of creating a hierarchy of directories for fc_host stats is in development.  

But we think that having our driver specific information under a subdirectory would make things look nicer. 

Can any of you linux guru's help me understand if this feature is currently in development? 
or 
is there any good way to tweak in and create a new subdirectory under the fc_host stats using the current fc_function_template? 

If this feature is not currently present or in dev can we add some code to the scsi_transport_fc.c to support this feature? 

Because we have a lot of driver specific information and we don't want to dump everything under the stats which can make things look a little messy. So we are planning to have a hierarchy so that we can sort out these properly.

Any help in this regard is really appreciated.

thanks in advance,


with regards,

KRISHNA CHAITANYA GUDIPATI
MS CS(COMPUTER NETWORKS)
UNIVERSITY OF SOUTHERN CALIFORNIA 
