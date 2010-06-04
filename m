From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Persistent Reservations implemented for SCST, iSCSI-SCST
 and Fibre Channel qla2x00t
Date: Sat, 05 Jun 2010 00:11:59 +0400
Message-ID: <4C095E0F.7020505@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We are pleased to announce that a full set of SCSI Persistent 
Reservations commands implemented for SCST, iSCSI-SCST and Fibre Channel 
qla2x00t drivers and available for download from the SCST SVN.

Persistent Reservations commands allow to use iSCSI-SCST and qla2x00t in 
cluster environments like Windows 2008 or RHEL clustering (for I/O fencing).

Hopefully, before 2.0 release other SCST target drivers will be updated 
to support Persistent Reservations as well.

SCST is a most advanced and high performance SCSI target subsystem for 
Linux. SCST allows creation of sophisticated storage devices from any 
Linux box. Home page of SCST is http://scst.sourceforge.net.

ISCSI-SCST is a relatively new, but already most advanced and high 
performance iSCSI target for Linux. Home page of iSCSI-SCST is 
http://iscsi-scst.sourceforge.net.

Qla2x00t is a Fibre Channel target driver for QLogic qla2xxx adapters. 
Home page of qla2x00t is http://scst.sourceforge.net/target_qla2x00t.html.

You can download SCST SVN by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk

Also we would like to announce intermediate version 2.0-rc2 of the SCST 
suit. Version 2.0-rc2 means that all the main changes for upcoming 2.0 
release finished and no more processing path changes are planned to be 
done before release. All the left to be done changes are going to fix 
only some outstanding problems in the internals of the SCST management 
interfaces. Hopefully, the work will be finished in a week-two.

Vlad
