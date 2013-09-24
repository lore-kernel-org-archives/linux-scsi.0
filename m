From: Errol Neal <eneal@businessgrade.com>
Subject: Megaraid SAS HA using shared disks
Date: Tue, 24 Sep 2013 13:52:32 -0400
Message-ID: <1380045152607594500@businessgrade.com>
Reply-To: eneal@businessgrade.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.businessgrade.com ([208.92.31.122]:34325 "EHLO
	smtp1.businessgrade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3IXR5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 13:57:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Curious. There were some commits made recently that make it possible using LSI's raid controllers. 
I checked out the LSI website and it sees that the Syncro product line has been updated to include support for Linux.
Can anyone comment on if these patches enable the feature stand-alone with ANY raid controller that uses this driver or were the patches delivered simply to support the Syncro controllers? 

Here is the thread I saw:

http://www.spinics.net/lists/linux-scsi/msg68444.html

Thanks for any information you can share. 
