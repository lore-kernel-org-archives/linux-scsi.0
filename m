From: Paul Collins <paul@briny.ondioline.org>
Subject: Re: resizing LUN (not file system) while the file system (ext3) i sonline
Date: Fri, 26 May 2006 13:41:26 +1000
Message-ID: <87mzd5h2qh.fsf@briny.internal.ondioline.org>
References: <4A8F680AC6EC43458BCAE06010D8E81B02841E4A@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:40714 "EHLO
	jenny.ondioline.org") by vger.kernel.org with ESMTP
	id S1030292AbWEZDn4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 23:43:56 -0400
In-Reply-To: <4A8F680AC6EC43458BCAE06010D8E81B02841E4A@CORPUSMX40A.corp.emc.com>
	(Kearnan Keith's message of "Thu, 25 May 2006 10:17:23 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kearnan_Keith@emc.com
Cc: lance.lmwang@gmail.com, linux-scsi@vger.kernel.org, admitriev@mentora.com, sct@redhat.com

Kearnan_Keith@emc.com writes:

> The scenario was that there was no free space on the PV which was made
> up of a singe partition /dev/sdc1.  The customer used back end tools to
> expand /dev/sdc1.  I couldn't figure out a way to let LVM know that
> /dev/sdc1 was now "bigger".  In the end we simply had the customer add a
> new PV (/dev/sdd1) in order to vgextend/lvextend the file system.

It looks like like LVM2's pvresize command should be able to do this.

-- 
Paul Collins
Melbourne, Australia

Dag vijandelijk luchtschip de huismeester is dood
