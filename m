From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old Opteron / Xeon servers
Date: Tue, 20 Mar 2007 11:54:57 +0100
Message-ID: <200703201154.58234.olaf.kirch@oracle.com>
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:51963 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbXCTKzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 06:55:50 -0400
In-Reply-To: <45FFB867.3060500@prie.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefan@prie.be
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tuesday 20 March 2007 11:33, Stefan Priebe wrote:
> 1.) I've bootet these systems through NFS and would like to access
> /dev/sda or /dev/sdb then. For example via fdisk and this does not work.

What do you mean by "booted through NFS"? Do you mean the machine
runs with the root file system mounted via NFS? Or does it mean you
booted, and started the NFS server?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
