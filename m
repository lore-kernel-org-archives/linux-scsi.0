From: "Andrey Dmitriev" <admitriev@mentora.com>
Subject: RE: resizing LUN (not file system) while the file system (ext3) isonline
Date: Thu, 25 May 2006 14:57:32 -0400
Message-ID: <009d01c6802d$156322e0$6600a8c0@andreyT43>
References: <1148562992.5115.47.camel@sisko.sctweedie.blueyonder.co.uk>
Reply-To: <admitriev@mentora.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p78-65.acedsl.com ([66.114.78.65]:19153 "EHLO
	karlson.dmitriev.net") by vger.kernel.org with ESMTP
	id S1030345AbWEYS56 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 14:57:58 -0400
In-Reply-To: <1148562992.5115.47.camel@sisko.sctweedie.blueyonder.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Stephen C. Tweedie'" <sct@redhat.com>, Kearnan_Keith@emc.com
Cc: linux-scsi@vger.kernel.org, lance.lmwang@gmail.com

So,

Should online resizing of the file system work out of the box?
Should online resizing of the LUN work out of the box?
When will the new e2fsprogs 'officially' officially be out?

I am a bit confused.

[root@bop-prod-db1 ~]# uname -a
Linux bop-prod-db1 2.6.9-22.0.1.ELsmp #1 SMP Tue Oct 18 18:39:02 EDT 2005
x86_64 x86_64 x86_64 GNU/Linux
[root@bop-prod-db1 ~]# rpm -qa|grep 2fs
e2fsprogs-1.35-12.3.EL4
e2fsprogs-devel-1.35-12.3.EL4
e2fsprogs-1.35-12.3.EL4

Thanks ,
-Andrey
-----Original Message-----
From: Stephen C. Tweedie [mailto:sct@redhat.com] 
Sent: Thursday, May 25, 2006 9:17 AM
To: Kearnan_Keith@emc.com
Cc: linux-scsi@vger.kernel.org; admitriev@mentora.com;
lance.lmwang@gmail.com; Stephen Tweedie
Subject: RE: resizing LUN (not file system) while the file system (ext3)
isonline

Hi,

On Thu, 2006-05-25 at 09:11 -0400, Kearnan_Keith@emc.com wrote:

> The article is dated 11/18/2005 and states "ext3 does not support online
> expansion...yet".  So yes it is very out of date.
> 
> I will get to work updating emc122304.  Did this behavior start in base
> RHEL4 (2.6.9-5)?  

Yes.  We patched our e2fsprogs to enable "-O resize_inode" in mke2fs by
default for RHEL-4 (the option has negligible effect other than to add a
tiny amount of space for ext3 group descriptors to grow into, enabling
online resize); upstream e2fsprogs has just enabled it by default too
for the forthcoming e2fsprogs-1.39 release.

Cheers,
 Stephen




