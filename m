From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 1.02
Date: Wed, 10 Oct 2007 09:07:48 -0400
Message-ID: <470CCEA4.4020007@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXJJNI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2007 09:08:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tomas Fasth <tomfa@debian.org>, Kumba <kumba@gentoo.org>

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

ChangeLog for sdparm-1.02 [20071008]
  - support mode page descriptors with
    <acronym_name>[.<descriptor_num] syntax
    - "2_<acronym>" type entries replaced by new syntax
    - support medium partition mpage (SSC) with partitions
      as descriptors
  - append relative target port identifier to SAS target
    port address with '-iq' option
  - add solaris port
  - place vendor specific data in sdparm_data_vendor.c
  - in the absence of an explicit transport or vendor,
    and if no match on mode page name or field, then try
    SAS transport
  - add block device characteristics VPD page
  - add protocol-specific logical unit information VPD
    page (SAS)
  - use new sg_lib sg_get_num_nomult()
  - place source in subversion repository
    - use svn:externals property to point to sg3_utils'
      include/ and lib/ directories
    - move some files around (e.g. sdparm.8 to doc/)


For more information and downloads see:
http://www.torque.net/sg/sdparm.html

A release announcement has been sent to freshmeat.net .

Doug Gilbert

