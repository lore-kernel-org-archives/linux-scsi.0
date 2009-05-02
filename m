From: Howard Wilkinson <howard@cohtech.com>
Subject: Status of aic79xx driver in the linux kernel
Date: Sat, 02 May 2009 13:34:00 +0100
Message-ID: <49FC3DB8.4030701@cohtech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from finsbury-fw1.cohtech.com ([193.150.189.1]:57862 "EHLO
	mailhost2.cohtech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754324AbZEBNf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 09:35:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fedora-kernel-list@redhat.com, linux-scsi@vger.kernel.org

I have been having some problems with an Adaptec 39320A-R card and have 
been poking around and found that the driver in the kernel claims to be 
derived from an Adaptec version 2.0.15 which was release in October 
2005! There is a later version on the Adaptec site from April 2007 - 
2.0.26.

I was wondering if anybody knows the actual status of the driver in the 
kernel i.e. has it diverged so far that the Adaptec updates are moot; 
have they already been incorporated into the kernel but the docs not 
updated to reflect this, or ...

I ask because I am trying to decide whether to invest the time to look 
at integrating the latest Adaptec drop to see if my problems go away.

Howard.

