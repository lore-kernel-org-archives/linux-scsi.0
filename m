From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 11:51:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Jan14.115140est.119077@cyborg.cybernetics.com>
References: <OF17AF196C.AE6043CD-ONC1256CAE.00549A53@de.ibm.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF17AF196C.AE6043CD-ONC1256CAE.00549A53@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: 'Martin Peschke3' <MPESCHKE@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

> Furthermore, does anybody know what the largest IDs are which are
> defined by any SCSI transport?

iSCSI identifies targets and initiators by world-wide unique name strings up
to 223 bytes in length.  An iSCSI initiator is additionally qualified by a
6-byte ISID value, and an iSCSI target is additionally qualified by a 16-bit
Portal Group Tag.  A full iSCSI I_T nexus is identified by the initiator
name string, the ISID, the target name string, and the portal group tag.

Anthony J. Battersby
Cybernetics

