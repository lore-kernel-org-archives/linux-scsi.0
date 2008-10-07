From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 00/12] Various hwmon patches
Date: Mon, 06 Oct 2008 18:18:24 -0700
Message-ID: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:42564 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbYJGBS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:18:26 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9719vb4031302
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:09:57 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971IPwe216540
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:18:25 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971IOpQ028098
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:18:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi all,

Here are a myriad of hwmon patches that I've been working on for (roughly)
2.6.28.  Please have a look and let me know what you think.

- Further elaboration of the hwmon sysfs interface for power meters
- New drivers: adt7462 (v2) and ics932s401
- adt7462 v2: Fix some mislabelling problems and make it autoload via DMI
- DMI based autoloading of various hwmon drivers for various IBM systems
- Automatic loading for i5k-amb driver
- Fix adt7470 mislabelling problems 
- Update adt7473 documentation
- adt7470/adt7473: Check input values from sysfs

--D
