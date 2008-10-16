From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: qla2xxx: NULL pointer dereference in 2.6.26.6 on module load
Date: Fri, 17 Oct 2008 01:15:02 +0200
Message-ID: <87bpxkt9mx.fsf@tac.ki.iif.hu>
References: <87prm0ziz7.fsf@tac.ki.iif.hu>
	<20081016154943.GF55003@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:44061 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYJPXPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2008 19:15:06 -0400
In-Reply-To: <20081016154943.GF55003@plap4-2.local> (Andrew Vasquez's message
	of "Thu, 16 Oct 2008 08:49:43 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Andrew Vasquez <andrew.vasquez@qlogic.com> writes:

> On Thu, 16 Oct 2008, Ferenc Wagner wrote:
>
>> This problem is not present in 2.6.18 nor 2.6.27, but I'd like to see
>> it fixed in the kernel of Debian Lenny, so came here with a couple of
>> questions.
>
> You'll want to backport the following commit to your 2.6.26.6 kernel:
>
> [SCSI] qla2xxx: Skip FDMI registration on ISP21xx/22xx parts.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=031e134e5f95233d80fb1b62fdaf5e1be587597c

Thanks, that indeed fixed it.  And backporting was trivial, the patch
applied without any change. :)  Is there a special reason why it
wasn't incorporated into 2.6.26.6?
-- 
Regards,
Feri.
