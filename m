From: "Deas, Jim" <James.Deas@warnerbros.com>
Subject: removable scsi drives
Date: Tue, 21 Oct 2003 10:34:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <S263201AbTJURfS/20031021173518Z+18811@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-64-236-243-31.twi.com ([64.236.243.31]:37627 "EHLO
	atwburmw02.twi.com") by vger.kernel.org with ESMTP id S263201AbTJURfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 13:35:18 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am working on a way to mount and unmount HD units on a SCSI chain
similar to the way it is done on Mac computers using hfs formatted disk.
 On kernel 2.4.20 I can unload the aic7xxx driver, swap drives, reload
the aic7xxx driver and mount the HFS formatted disk. This works but is
time consuming and resets the whole scsi chain making it very
inflexible.

 I want to stream line this procedure but I am not sure of a safe way.
Would it be safe remove a scsi drive that is not mounted and to discover
a new drive in its place using SG_SCSI_RESET [device]?

Thanks for any help
J. Deas
 

