From: James Smart <James.Smart@emulex.com>
Subject: Re: [Bug 48871] drivers/scsi/lpfc/lpfc_init.c: 2 * Buffer is accessed
 out of bounds
Date: Wed, 31 Oct 2012 15:02:12 -0400
Message-ID: <509175B4.9080004@emulex.com>
References: <bug-48871-11613@https.bugzilla.kernel.org/> <20121017102635.A6DB211FC6B@bugzilla.kernel.org>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:53223 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2JaTCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 15:02:13 -0400
In-Reply-To: <20121017102635.A6DB211FC6B@bugzilla.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

Thank You.

This problem has been addressed by patch5 of our 8.3.36 patch kit: See  
http://marc.info/?l=linux-scsi&m=135170915426118&w=2

-- james s


On 10/17/2012 6:26 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48871
>
>
> Alan <alan@lxorguk.ukuu.org.uk> changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |alan@lxorguk.ukuu.org.uk
>            Component|Other                       |Other
>           AssignedTo|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
>                     |sdl.org                     |ugs.osdl.org
>              Product|Drivers                     |SCSI Drivers
>
>
>
>

