From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: How to set DPOFUA=0 ?
Date: Tue, 29 Dec 2015 19:04:20 +0100
Message-ID: <n5uhv4$dqe$1@ger.gmane.org>
References: <n5kqb4$k8n$1@ger.gmane.org> <n5tqsl$5eg$2@ger.gmane.org>
 <CAGRGNgWG+4YAgD1P=6KZ+U3CxHmCr06rOViHJhW8wRXFcDsThA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56002 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbbL2SEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 13:04:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1aDydJ-0001f9-6E
	for linux-scsi@vger.kernel.org; Tue, 29 Dec 2015 19:04:29 +0100
Received: from ip4d14b373.dynamic.kabel-deutschland.de ([77.20.179.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Dec 2015 19:04:29 +0100
Received: from for-gmane by ip4d14b373.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Dec 2015 19:04:29 +0100
In-Reply-To: <CAGRGNgWG+4YAgD1P=6KZ+U3CxHmCr06rOViHJhW8wRXFcDsThA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Julian Calaby wrote on 12/29/2015 12:43 PM:
> Hi,
>
> On Tue, Dec 29, 2015 at 10:30 PM, U.Mutlu <for-gmane@mutluit.com> wrote:
>> After this nigtmare-ish experience I would suggest the debian maintainers
>> to trash the default jessie kernel 3.16 and replace it with the above
>> 4.2 kernel; otherwise unexperienced users will wonder why their new SSD etc.
>> isn't working in debian/ubuntu & co., as happened to me... :-(
>
> Have you reported this as a bug against Jessie's kernel package?

I wasn't sure if that really was a bug, so I just first asked for
info/confirmation here, and later also in their mailing list ( 
debian-kernel@lists.debian.org ) as it first seemed to be a SCSI and/or USB issue.
Then I tried a newer kernel and the problem was gone.
Yes, I informed the other list too about the solution.



