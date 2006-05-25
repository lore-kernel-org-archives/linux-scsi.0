From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: RE: resizing LUN (not file system) while the file system (ext3) i
	sonline
Date: Thu, 25 May 2006 14:16:32 +0100
Message-ID: <1148562992.5115.47.camel@sisko.sctweedie.blueyonder.co.uk>
References: <4A8F680AC6EC43458BCAE06010D8E81B02841D4B@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47309 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965169AbWEYNQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 09:16:42 -0400
In-Reply-To: <4A8F680AC6EC43458BCAE06010D8E81B02841D4B@CORPUSMX40A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kearnan_Keith@emc.com
Cc: linux-scsi@vger.kernel.org, admitriev@mentora.com, lance.lmwang@gmail.com, Stephen Tweedie <sct@redhat.com>

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


