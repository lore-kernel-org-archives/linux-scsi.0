From: sullivan <sullivan@austin.ibm.com>
Subject: [RFC] Persistent naming of scsi devices
Date: Wed, 5 Jun 2002 15:13:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020605151336.A1139@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mochel@osdl.org

Thanks for your postings to the original RFC submitted under this subject. Based on your feedback two utilities are now available at http://oss.software.ibm.com/devreg/
a. scsiname utility
	- Makes sg calls to collect device info used to make naming decisions
	- Hooked into the hotplug interface using Doug Gilbert's scsimon patch
	- Targeted specifically to scsi devices
	- Implemented completely in userspace

b. devnaming utility
	- Utilizes Patrick Mochel's driverfs fs to collect device info
	- Can easily be extended to support other device types (non scsi)
	- Includes a kernel patch to create/publish device info in driverfs
	- Hooked into hotplug interface using scsimon patch

Why two utilities? I see scsiname providing an immediate fix for providing a persistent set of /dev scsi names across boots. The devnaming utility is more long term in that it anticipates that driverfs will evolve into providing the device information necessary, removing the need for interfacing through sg. The config and hotplug portions of the utilities are consistent and should (hopefully) provide a smooth migration path.

I'd appreciate feedback from anyone that has the interest and the time to take a further look.



