From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Bug 85751] iSCSI initiator lockup during logout
Date: Tue, 07 Oct 2014 20:29:49 +0200
Message-ID: <5434311D.5040801@acm.org>
References: <bug-85751-11613@https.bugzilla.kernel.org/> <bug-85751-11613-AIXQdLQp7t@https.bugzilla.kernel.org/> <54341CF9.609@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:47316 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaJGS3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 14:29:52 -0400
In-Reply-To: <54341CF9.609@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 10/07/14 19:03, Mike Christie wrote:
> On 10/07/2014 11:42 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> * iscsiadm -m discovery -p 192.168.1.124 -t st
>> * iscsiadm -m node -p 192.168.1.124 -l
>> (something went wrong at the target side and the iSCSI initiator tried to
>> relogin)
>
> Did this login command ever complete normally? Did you ctrl-c it or did
> you run the logout command below in another terminal?

Hello Mike,

Thanks for jumping in. I had indeed interrupted login via Ctrl-C because 
login took longer than expected.

Bart.

