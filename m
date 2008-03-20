From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6280] new line of Xyratex RAID products and a patch to update for 2.4.x non-sequential LUN mapping
Date: Thu, 20 Mar 2008 09:53:18 -0700 (PDT)
Message-ID: <20080320165318.6672C11D10A@picon.linux-foundation.org>
References: <bug-6280-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbYCTQxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 12:53:37 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2KGrIv6032751
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 09:53:19 -0700
In-Reply-To: <bug-6280-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6280





------- Comment #4 from pkoutoupis@sbcglobal.net  2008-03-20 09:53 -------
Well, our SCSI level reports 3. But this patch was specific to allow
non-contiguous LUN mappings for our vendor/model array products on the 2.4.x
kernel only. This is never a problem on 2.6.

 Seeing how we discontinued support for the 2.4.x and that includes our older
products that were qualified for it, I do not see the need to press on with
this patch.

 The bug can be closed. Thank you all for your assistance.

 Regards,

 Petros Koutoupis

bugme-daemon@bugzilla.kernel.org wrote:
http://bugzilla.kernel.org/show_bug.cgi?id=6280





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-03-20 06:52
-------
Reply-To: James.Bottomley@HansenPartnership.com

On Thu, 2008-03-20 at 00:34 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=6280
> 
> 
> protasnb@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |protasnb@gmail.com
>          AssignedTo|scsi_drivers-other@kernel-  |linux-scsi@vger.kernel.org
>                    |bugs.osdl.org               |
> 
> 
> 
> 
> ------- Comment #2 from protasnb@gmail.com  2008-03-20 00:34 -------
> Petros,
> This bugzilla is about 2.6.XX. Do you think your patch makes sense for latest
> kernels, or this support is already implemented there?

Depends what SCSI level the array reports.  If > 2 then the REPORT_LUNS
scan will already have taken care of all of this.

James


Well, our SCSI level reports 3. But this patch was specific to allow
non-contiguous LUN mappings for our vendor/model array products on the 2.4.x
kernel only. This is never a problem on 2.6.<br> <br> Seeing how we
discontinued support for the 2.4.x and that includes our older products that
were qualified for it, I do not see the need to press on with this patch.<br>
<br> The bug can be closed. Thank you all for your assistance.<br> <br>
Regards,<br> <br> Petros
Koutoupis<br><br><b><i>bugme-daemon@bugzilla.kernel.org</i></b>
wrote:<blockquote class="replbq" style="border-left: 2px solid rgb(16, 16,
255); margin-left: 5px; padding-left: 5px;">
http://bugzilla.kernel.org/show_bug.cgi?id=6280<br><br><br><br><br><br>-------
Comment #3 from anonymous@kernel-bugs.osdl.org  2008-03-20 06:52
-------<br>Reply-To: James.Bottomley@HansenPartnership.com<br><br>On Thu,
2008-03-20 at 00:34 -0700, bugme-daemon@bugzilla.kernel.org<br>wrote:<br>&gt;
 http://bugzilla.kernel.org/show_bug.cgi?id=6280<br>&gt; <br>&gt; <br>&gt;
protasnb@gmail.com changed:<br>&gt; <br>&gt;            What    |Removed       
             |Added<br>&gt;
----------------------------------------------------------------------------<br>&gt;
                 CC|                            |protasnb@gmail.com<br>&gt;    
     AssignedTo|scsi_drivers-other@kernel-  |linux-scsi@vger.kernel.org<br>&gt;
                   |bugs.osdl.org               |<br>&gt; <br>&gt; <br>&gt;
<br>&gt; <br>&gt; ------- Comment #2 from protasnb@gmail.com  2008-03-20 00:34
-------<br>&gt; Petros,<br>&gt; This bugzilla is about 2.6.XX. Do you think
your patch makes sense for latest<br>&gt; kernels, or this support is already
implemented there?<br><br>Depends what SCSI level the array reports.  If &gt; 2
then the REPORT_LUNS<br>scan will already have taken care of all of
this.<br><br>James<br><br><br>-- <br>Configure bugmail:
 http://bugzilla.kernel.org/userprefs.cgi?tab=email<br>------- You are
receiving this mail because: -------<br>You reported the bug, or are watching
the reporter.<br></blockquote><br>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
