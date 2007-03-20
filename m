From: Stefan Priebe <stefan@prie.be>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
Date: Tue, 20 Mar 2007 12:20:14 +0100
Message-ID: <45FFC36E.1070905@prie.be>
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com>
Reply-To: stefan@prie.be
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server077.de-nserver.de ([62.27.12.245]:59637 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXCTLUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 07:20:37 -0400
In-Reply-To: <200703201154.58234.olaf.kirch@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hello!

Here a some more information:
- sometimes the whole systems crash - sometimes they are still alive
- if they are alive fdisk consumes 99% CPU
- fdisk cannot be killed also not with kill -9
- the same happens with a cat on /dev/sdX
- no problem when trying to access /dev/hdX

Stefan

Olaf Kirch schrieb:
> On Tuesday 20 March 2007 11:33, Stefan Priebe wrote:
>> 1.) I've bootet these systems through NFS and would like to access
>> /dev/sda or /dev/sdb then. For example via fdisk and this does not work.
> 
> What do you mean by "booted through NFS"? Do you mean the machine
> runs with the root file system mounted via NFS? Or does it mean you
> booted, and started the NFS server?
> 
> Olaf

