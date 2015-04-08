From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 00/20] mpt3sas: driver update
Date: Wed, 8 Apr 2015 11:13:04 +0530
Message-ID: <CAK=zhgqRR5f-QJLT18xLWOnBXVeoE2if5rEbskXyDN3H7LSWjg@mail.gmail.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150405160905.GA15216@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35338 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbDHFnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 01:43:05 -0400
Received: by widdi4 with SMTP id di4so41667028wid.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2015 22:43:04 -0700 (PDT)
In-Reply-To: <20150405160905.GA15216@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "jejb@kernel.org" <jejb@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>

Hi Chris,

There are no corresponding mpt2sas driver's patches, The last phase
for mpt2sas drivers is Phase20 and this phase driver is already exits
in the upstream kernel. Also mpt2sas driver is completely in maintains
mode and there won't be any new features.

Whereas mpt3sas is at its initial baseline with a healthy road map
ahead and also we are planning to use same mpt3sas driver for next
upcoming Avago IT HBA's. So merging mpt2sas driver with mpt3sas driver
may break mpt2sas driver functionality in future, also it will be over
head of the maintainer to always check for the backward compatibility
of merged driver with the mpt2sas driver.

Regards,
Sreekanth

On Sun, Apr 5, 2015 at 9:39 PM, Christoph Hellwig <hch@infradead.org> wrote:
> This seems to be missing the corresponding mpt2 updates.  Nak to
> anything that gets these drivers further out of sync.
>
> Btw, I still need a second ACK for
> http://www.spinics.net/lists/linux-scsi/msg82027.html
> as well, so we can start getting rid of this duplication mess.
