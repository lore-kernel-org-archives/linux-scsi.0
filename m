From: sullivan <sullivan@austin.ibm.com>
Subject: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 09:18:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020408091844.L7333@austin.ibm.com>
Reply-To: sullivan@austin.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: (from sullivan@localhost)
	by ibm.com (8.11.6/8.11.6) id g38FIik31062
	for linux-scsi@vger.kernel.org; Mon, 8 Apr 2002 09:18:44 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been working on a prototype to allow the persistent naming of scsi devices across boots. The prototype attempts to address the namespace slippage that occurs when names are assigned based on discovery order or topology, and a hardware configuration change occurs. It does this by assigning names based on the characteristics of the device.

The prototype and more detailed info can be found at:
http://oss.software.ibm.com/devreg/

The prototype utilizes 3 components:
1. driverfs to collect and publish the characteristics of the device
2. devfs to generate insertion and removal events
3. devfsd library to handle the events, parse driverfs, and apply the naming logic.

I am also currently working on a non devfs version that uses /sbin/hotplug as the event generation mechanism.

I would welcome any thoughts, comments, or suggestions.
