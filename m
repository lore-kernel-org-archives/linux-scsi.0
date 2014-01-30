From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST iSER target driver is available for testing
Date: Wed, 29 Jan 2014 19:21:09 -0800
Message-ID: <52E9C525.6000603@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm glad to announce that SCST iSER target driver is available for testing from the SCST SVN iser branch. You can download it either by command:

$ svn checkout svn://svn.code.sf.net/p/scst/svn/branches/iser iser-scst-branch

or by clicking on "Download Snapshot" button on http://sourceforge.net/p/scst/svn/HEAD/tree/branches/iser page.

Big thanks to Yan Burman and Mellanox Technologies who developed it!

SCST is SCSI target mode stack for Linux. SCST allows creation of sophisticated storage devices, which provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Majority of recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Vlad
