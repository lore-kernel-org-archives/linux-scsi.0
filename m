From: Mike Anderson <andmike@us.ibm.com>
Subject: LDM scsi upper level updates and scsihosts parm
Date: Fri, 30 May 2003 18:08:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030531010844.GA25468@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:8389 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264094AbTEaAwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 20:52:36 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h4V15uuT254006
	for <linux-scsi@vger.kernel.org>; Fri, 30 May 2003 21:05:56 -0400
Received: from dyn9-47-17-195 (DYN318097.beaverton.ibm.com [9.47.17.142])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h4V15uve178784
	for <linux-scsi@vger.kernel.org>; Fri, 30 May 2003 19:05:56 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The sysfs changes to allow the upper level to bind through the driver
model interfaces breaks the usage of the scsihosts parm. I did not
notice this the other day as I was running with one built-in driver and
many modules.

I know there are issues with using scsihosts today (i.e., does not
work if you come in after the upper levels have inited).

Are we going to remove the scsihosts parm or do we need a solution for
this?

-andmike
--
Michael Anderson
andmike@us.ibm.com

