From: Tarjei Huse <tarjei@scanventure.no>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Sun, 14 Jan 2007 16:30:41 +0100
Message-ID: <45AA4CA1.3050909@scanventure.no>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net> <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no> <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no> <45A81BBF.7050104@us.ibm.com>
Reply-To: tarjei@nu.no
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.bergfald.no ([213.158.252.226]:1557 "EHLO
	mail2.bergfald.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbXANPan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jan 2007 10:30:43 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail2.bergfald.no (Postfix) with ESMTP id 9EFF4296F6A
	for <linux-scsi@vger.kernel.org>; Sun, 14 Jan 2007 16:30:42 +0100 (CET)
Received: from mail2.bergfald.no ([127.0.0.1])
 by localhost (mail2 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 08222-08 for <linux-scsi@vger.kernel.org>;
 Sun, 14 Jan 2007 16:30:41 +0100 (CET)
Received: from [192.168.0.118] (backup.bergfald.no [84.210.0.203])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.bergfald.no (Postfix) with ESMTP id 3D374296F61
	for <linux-scsi@vger.kernel.org>; Sun, 14 Jan 2007 16:30:41 +0100 (CET)
In-Reply-To: <45A81BBF.7050104@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(note: I've sent this email with CC to Darrick ++ earlier, but forgot to 
remove html crap. Sorry about that).

Darrick J. Wong wrote:
> Tarjei Huse wrote:
>
>   
>> I did the opposite, I downloaded the git tree and tried to compile it.
>> Since I got an error, I added the scsi-rc-fixes patch (the scsi-misc and
>> aic94xx didn't apply cleanly so I guessed they were already in the git
>> tree), the 39-libsas-fix-thypos,
>> ../11-aic94xx-dont-eat-query-task-results_1, 17-aic94xx-fix-fw-leak_1.
>>     
>
> The aic94xx-sas git tree is a requirement.  Something along the lines of:
>
> $ cg-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> $ cd linux-2.6
> $ cg-branch-add scsi-misc git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> $ cg-branch-add scsi-rc git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> $ cg-branch-add aic94xx git://git.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git
> $ cg-update scsi-misc
> $ cg-update scsi-rc
> $ cg-update aic94xx
>
> *Then* apply patches from my patch set.
>   
Duh! Thanks :-)

After doing as you suggested, and running make oldconfig using the 
configuration from Ubuntu Dapper (2.6.15-23-server) and the stock Ubuntu 
Edgy I get the same error when booting the kernel:

PCI: BIOS Bug: MCFG area at e00000000 is not E820-reserved
PCI: Not using MMCONFIG
PCI Cannot allocate resource region 7 of bridge 0000:00:01.1
PCI Cannot allocate resource region 8 of bridge 0000:00:01.1
PCI Cannot allocate resource region 9 of bridge 0000:00:01.1
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown 
wn-block(0,0)

Is this some missing compile option or a bug?

Again thank you for your help.

Kind regards,
Tarjei

> --D
>   

