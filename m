From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Thu, 14 Apr 2016 22:43:00 -0400
Message-ID: <yq1r3e7sibv.fsf@sermon.lab.mkp.net>
References: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
	<1459536717.30035.113.camel@localhost.localdomain>
	<56FEC864.5050008@stratus.com>
	<1459541058.30035.126.camel@localhost.localdomain>
	<38b26e94d10098596fb11cf9bafcb7c0@mail.gmail.com>
	<c762138f15c771759b451b16d97f199e@mail.gmail.com>
	<570B93C9.3040102@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50612 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbcDOCnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2016 22:43:21 -0400
In-Reply-To: <570B93C9.3040102@stratus.com> (Joe Lawrence's message of "Mon,
	11 Apr 2016 08:08:41 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Chaitra Basappa <chaitra.basappa@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, emilne@redhat.com, linux-scsi@vger.kernel.org, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>

>>>>> "Joe" == Joe Lawrence <joe.lawrence@stratus.com> writes:

Joe> Do we know why f1c35e6aea579 "mpt2sas: RESCAN Barrier work is added
Joe> in case of HBA reset" was unneeded for the mpt3 version?  If that
Joe> is interesting, that info could be added to v2 commit message as
Joe> well.

Chaitra?

-- 
Martin K. Petersen	Oracle Linux Engineering
