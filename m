From: Marc Bejarano <beej@alum.mit.edu>
Subject: affordable SAS HBA recommendation?
Date: Thu, 06 Mar 2008 15:53:44 -0500
Message-ID: <200803062053.m26Krkb6020110@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colby.verdasys.com ([69.20.67.85]:33285 "EHLO
	colby.verdasys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYCFVyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:54:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

i've been having some data corruption problems and i'd like to try 
using a different driver/HBA to see if they go away.  i'm currently 
using LSI SAS3801E HBA's which use the mptsas driver.  since i use 
linux md for RAID, i'd rather not spend a lot of money on RAID 
silicon that i don't want.

ideally, i'd love a reasonably priced PCIe SAS HBA with an in-tree 
driver supported by RHEL 5.1.  any suggestions?

tia,
marc

