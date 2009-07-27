From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Subject: RFC: be iscsi driver
Date: Mon, 27 Jul 2009 12:55:17 -0700
Message-ID: <1248724523-10999-1-git-send-email-jayamohank@serverengines.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Hi

   I am sending the  open-iscsi based storage driver for ServerEngines
10 Gbps Adapter for review. The Adapter is Multi-Function device that
provides NIC/iSCSI/FCOE Functionality.

   The driver works in Full Hardware Offload mode utilizing the hooks provided
   by open-iscsi layer.

   This patch is made against the latest linus tree, 2.6.31-rc4.
        
   The series of  patches are described below:

   [PATCH 1/6]: This file contains all routines for Initiallization/Teardown, 
   registering with upper layers, IO Handling, allocation/free etc.

   [PATCH 2/6]: These are the low level routines to talk to the chip for 
   management commands.

   [PATCH 3/6]: The iscsi hooks to interact with open-iscsi layer.

   [PATCH 4/6]: The Firmware Commands that are used for Management action
   like setup /tear down a connection etc.

   [PATCH 5/6]: The Makefile and Kconfig for beiscsi driver.

   [PATCH 6/6]: The modified MAINTAINERS file with beiscsi added.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>

---
