From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: blktrace for all SCSI devices
Date: Wed, 13 Jun 2007 13:34:17 +0200
Message-ID: <20070613113417.GA14694@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:39603 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbXFMLeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 07:34:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org

As a follow-up to earlier discussions about adding statistics to the
SCSI layer (http://lkml.org/lkml/2006/9/26/151), i am looking what
data blktrace can provide.

One problem is that blktrace currently can only get the trace data
from block device files. This excludes retrieving trace data from
other SCSI devices, especially from tape drives. Looking at the code,
the SCSI layer internally uses the same request_queue per device. It
looks like the blktrace ioctls as interface to userspace are the first
thing that is missing. Is this all?

What would be a going idea to make the blktrace ioctls available for
all SCSI devices? My first approach would be to add them to the sg
devices. Any comments?

If there are now objections, i will try to implement the ioctls for sg
devices, to see if this actually works.

--
Christof Schmitt
