From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 0/8] aic94xx: sas code clean-up
Date: Tue, 09 May 2006 14:13:31 -0700
Message-ID: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:6115 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750750AbWEIVNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2006 17:13:47 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49LDgPw005907
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:13:42 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49LDgUi255944
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:13:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49LDguq017594
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:13:42 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49LDgYa017564
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:13:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

These patches were created in response to the comments from this earlier
email: 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114624643916659&w=2

First off, thank you Christoph for your comments.  I am working to
address them, starting with the ones that are easiest to implement.
Follows is a set of patches that address the following concerns:

1) Move the sas readme to the Documents dir-- this still needs to be
written so that it 'matches reality', but I want to merge the sas*.h
files to libsas.h and sas.h first
2) Remove the sas_common.c file
3) Remove the //depot SCM comments
4) Remove the expander_conf.c from the kernel tree
5) Remove various inline functions
6) Move list_each_entry_reverse_safe from sas_discover.h to list.h
7) Remove the long queue implementation comment
8) Use bitops for setting and clearing bits

These patches are just a start and I will continue to address these
issues.

Regards,

Alexis

