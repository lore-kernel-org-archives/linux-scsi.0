From: Scott Merritt <Scsi@SpoofWorks.com>
Subject: SCSI cable advice ?
Date: Fri, 7 Feb 2003 09:23:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030207092351.329ccf01.Scsi@SpoofWorks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am redoing my SCSI - LVD/Wide configuration and would appreciate
advice on the cabling.  I am currently using CRU (removable) dataports
with the supplied adaptec internal SCSI LVD/SE WIDE cable.

I would like to switch to the CRU backplane product that mounts
several of the frame receivers on a (passive) 6 layer backplane.
My concern is the short distance between the SCSI drives.  The
research I have done states that the distance between the drives
should be at least 3 times the stub length to avoid "clustering"
(also see Annex C in X3T10/1071D).  My (limited) understanding is
that this configuration is recommended to reduce the effects of
reflections from the impedance mismatch at connection points.

This implies to me that such backplane products (and typical RAID
enclosures in general) are running with reduce margins (especially
if external devices are also connected to the SCSI bus) -and-
that a conventional cable approach between separate unit is
preferred.  Is this conclusion correct ???

Thanks, Scott.


