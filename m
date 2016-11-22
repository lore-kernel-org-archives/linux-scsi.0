From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 18:28:18 +0200
Message-ID: <CAPrnrPCFHZbb_GW0Kv-sptAu-qw74k0m4=Lk9wTDQq=uzwM_ZA@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <CAPrnrPB1kJZkzbJNVrtKLp_w9Ts8jmOzQczYwANodV=HerCm=w@mail.gmail.com>
 <858849309.1558836.1479828683078.JavaMail.zimbra@redhat.com> <20161122160055.7q7oruuapsfwlsbu@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33627 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756378AbcKVQ2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 11:28:19 -0500
Received: by mail-io0-f196.google.com with SMTP id j92so11516547ioi.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 08:28:19 -0800 (PST)
In-Reply-To: <20161122160055.7q7oruuapsfwlsbu@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Laurence Oberman <loberman@redhat.com>, "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

> @Eyal is this with a physical or virtual host? And what kind of HBA do you
> have? Just in case it makes a difference.


All physical hosts,

Original problem was detected on qlogic FC HBA (Ubuntu 16.04)

To check if this is transport related, we reproduced the 0 byte
corruption on iSCSI too.

To check if the problem is our user space tool we ran with with iSCSI + tcpdump
and learnt that the problem is probably in the kernel and is not
related to the transport selected.

Later to learn more I ran "sg_mmap_read" on several devices: local
hard disks, FC cards and iSCSI.
