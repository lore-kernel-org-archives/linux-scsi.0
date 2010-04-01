From: Joel Becker <Joel.Becker@oracle.com>
Subject: [LSF/VM TOPIC] Generic SAN Management via Oracle VM Storage
 Connect Plugin.
Date: Wed, 31 Mar 2010 18:05:40 -0700
Message-ID: <20100401010539.GF28680@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:47413 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab0DABGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 21:06:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: linux-scsi@vger.kernel.org

[ I was asked to Cc: linux-scsi, so here it is ]


[Topic]
Generic SAN Management via Oracle VM Storage Connect Plugin.

[Abstract]
Managing storage in the SAN often requires using a different tool for
each vendor in the environment.  Oracle has defined a plugin interface
for SAN management, the (sorry about the mouthful) Oracle VM Storage
Connect Plugin.  The important part is that many of our storage partners
have agreed to not only help, but actively author plugins for their
storage hardware.

While initiated for the Oracle VM product, I've written a standalone
application that uses the plugin, giving a unified view of storage that
can be managed from one place.  The program will be open source, of
course.  I'm looking for input from storage folks at LFS on what
I can do to make this even more useful to general SAN management.

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127


-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
