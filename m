From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST 3.0 released
Date: Fri, 19 Sep 2014 23:39:04 -0700
Message-ID: <541D2108.1090308@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce that SCST 3.0 has just been released. This release includes SCST 
core, target drivers iSCSI-SCST for iSCSI, including iSER support (thanks to 
Mellanox!), qla2x00t for QLogic Fibre Channel adapters, ib_srpt for InfiniBand SRP, 
fcst for FCoE and scst_local for local loopback-like access as well as SCST management 
utility scstadmin. Also separately you can download from Emulex development portal 
stable and fully functional target driver for the current generation of Emulex Fibre 
Channel adapters.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated 
storage devices, which provide advanced functionality, like replication, thin 
provisioning, deduplication, high availability, automatic backup, etc. Majority of 
recently developed SAN appliances, especially higher end ones, are SCST based. It might 
well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen!

Vlad
