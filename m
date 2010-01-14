From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Thu, 14 Jan 2010 15:01:59 -0800
Message-ID: <20100114150159.caffb336.akpm@linux-foundation.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
	<201001142227.o0EMRIVt019573@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762Ab0ANXCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2010 18:02:34 -0500
In-Reply-To: <201001142227.o0EMRIVt019573@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: barzog@telecom.by
Cc: linux-scsi@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, James Smart <James.Smart@Emulex.Com>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 14 Jan 2010 22:27:18 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14877
> 
> 
> Andrew Morton <akpm@linux-foundation.org> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |akpm@linux-foundation.org,
>                    |                            |james.smart@emulex.com
>           Component|PCI                         |Other
>          AssignedTo|drivers_pci@kernel-bugs.osd |scsi_drivers-other@kernel-b
>                    |l.org                       |ugs.osdl.org
>             Product|Drivers                     |SCSI Drivers
>          Regression|No                          |Yes
> 
> 
> 
> 
> --- Comment #2 from Andrew Morton <akpm@linux-foundation.org>  2010-01-14 22:27:15 ---
> Thanks.  I'll mark this as a regression, shall reassign to scsi and shall ask
> you to email a signed-off version of that patch.
> 

Oleg, please send that lpfc patch via emailed reply-to-all to this email. 
Include a brief description for the changelog and a Signed-off-by: as
per Documentation/SubmittingPatches, thanks.


