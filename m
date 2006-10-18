From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Wed, 18 Oct 2006 15:24:06 -0700
Message-ID: <1161210246.3204.17.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:40409 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1423092AbWJRWYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 18:24:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have had a tough time tracking this one down, however I can say for
certain that the 29320 is really having trouble if a LUN is power
cycled.

I don't have access to a BUS analyzer right now, but here is my
regression.

1.  Hook an external SCSI array/disk to a 29320.
2.  Power up SCSI array/disk
3.  Power up PC with 29320.
4.  When PC has booted, login and test device by creating a file
    system, eg. mkfs /dev/sda (or whatever disk the array is called on
    ur machine).
5.  Power cycle array/disk
6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
ensues.



This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.

Any ideas?

Sean

