From: "Ming Zhang" <mingz@ele.uri.edu>
Subject: about scsi_hostlist
Date: Sun, 17 Nov 2002 17:11:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211172212.gAHMCp99017977@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from salangane (ip68-9-255-122.ri.ri.cox.net [68.9.255.122])
	by leviathan.ele.uri.edu (8.12.2/8.12.2) with SMTP id gAHMCp99017977
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 17:12:53 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi, I meet a problem when port my code to 2.5.47.
My goal is to get all scsi disk Scsi_Device pointers.

For 2.4.18, I can use scsi_hostlist to travel through the list and get all pointer by comparing type if TYPE_DISK. But in 2.5.47, there is no such pointer. And that scsi_host_list can not be used.

Does anyone know how to get around to this? 

Thanks in advance.



Best regards. 


Ming Zhang
------------------------------
Member of IEEE, ACM
mingz@ele.uri.edu
http://www.ele.uri.edu/~mingz
1(401)874-4859

Department of Electrical and Computer Engineering
University of Rhode Island

4 East Alumni Ave. Kingston, RI, 02881




