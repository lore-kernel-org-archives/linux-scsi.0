From: James Pearson <james-p@moving-picture.com>
Subject: Re: Problems seeing raid array attached to a qla2312
Date: Tue, 07 Sep 2004 16:56:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413DDA46.4050400@moving-picture.com>
References: <41248D91.5070100@moving-picture.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:13786 "EHLO
	moving-picture.com") by vger.kernel.org with ESMTP id S268196AbUIGP4z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 11:56:55 -0400
Received: from minion.mpc.local ([172.16.11.112] helo=moving-picture.com)
	by moving-picture.com with esmtp (Exim 4.24)
	id 1C4iL0-0001fZ-Dh
	for linux-scsi@vger.kernel.org; Tue, 07 Sep 2004 16:56:54 +0100
In-Reply-To: <41248D91.5070100@moving-picture.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Pearson wrote:
> I'm having problems seeing a Fibrenetix VP-1242-FC raid array via a 
> qla2312 HBA on a dual Xeon box running a RHEL3.0 clone - using a 2.4.21 
> based kernel.
> 
> The first port on the qla2312 has a Quantum tape library and two SDLT 
> tape drives - which the OS can see fine.
> 
> The raid array is attached to the 2nd port on the qla2312 - it is 
> configured with 3 volumes at luns 0, 1 and 2 - unfortunately, the OS 
> can't 'see' the 3 disk volumes ...
> 

This turned out to be a problem with the firmware on the raid array - 
upgrading to a newer version fixed this issue.

James Pearson
