From: Paul Collins <paul@briny.ondioline.org>
Subject: Re: resizing LUN (not file system) while the file system (ext3) i sonline
Date: Thu, 01 Jun 2006 23:38:53 +1000
Message-ID: <87wtc1j8r6.fsf@briny.internal.ondioline.org>
References: <4A8F680AC6EC43458BCAE06010D8E81B028424AF@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:55304 "EHLO
	jenny.ondioline.org") by vger.kernel.org with ESMTP
	id S1750790AbWFANnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 09:43:50 -0400
In-Reply-To: <4A8F680AC6EC43458BCAE06010D8E81B028424AF@CORPUSMX40A.corp.emc.com>
	(Kearnan Keith's message of "Fri, 26 May 2006 08:24:36 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kearnan_Keith@emc.com
Cc: lance.lmwang@gmail.com, linux-scsi@vger.kernel.org, admitriev@mentora.com, sct@redhat.com

Kearnan_Keith@emc.com writes:

> Perfect, thank you Paul!  
>
> That command wasn't around in the version I initially tested, SLES9sp2:
> lvm2-2.00.33-1.3.  
> I see that it is in RHEL4u3: lvm2-2.02.01-1.3.RHEL4.  
>
> Does anyone know which version of LVM it was introduced in?

The changelog for version 2.02.00, released 10 November 2005, has an
entry "A pvresize implementation."  There are no other references to
it (or to PV resizing in general) in the file, so that must be it.

-- 
Paul Collins
Melbourne, Australia

Dag vijandelijk luchtschip de huismeester is dood
