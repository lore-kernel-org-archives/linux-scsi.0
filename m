From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [PATCH V4 00/11] megaraid_sas: Updates for scsi-next
Date: Sun, 11 Dec 2016 09:04:15 -0500
Message-ID: <31821eea883f75e4345984d6a5761d82@mail.gmail.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com> <20161207073122.GB26970@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38851 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbcLKOES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2016 09:04:18 -0500
Received: by mail-wm0-f46.google.com with SMTP id f82so30600287wmf.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2016 06:04:17 -0800 (PST)
In-Reply-To: <20161207073122.GB26970@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@kernel.org, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, Christopher Owens <christopher.owens@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>, thenzl@redhat.com

Hi Chris,

I will be rebasing to include " pci_alloc_irq_vectors conversion from
Hannes" in the next version of the patch

Thanks
sasi

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Wednesday, December 07, 2016 2:31 AM
To: Sasikumar Chandrasekaran
Cc: jejb@kernel.org; hch@infradead.org; linux-scsi@vger.kernel.org;
Sathya.Prakash@broadcom.com; linux-kernel@vger.kernel.org;
christopher.owens@broadcom.com; kiran-kumar.kasturi@broadcom.com;
thenzl@redhat.com
Subject: Re: [PATCH V4 00/11] megaraid_sas: Updates for scsi-next

This seems to be missing the pci_alloc_irq_vectors conversion from Hannes?
