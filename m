From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 17:00:55 +0100
Message-ID: <20161122160055.7q7oruuapsfwlsbu@linux-x5ow.site>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain>
 <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain>
 <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <CAPrnrPB1kJZkzbJNVrtKLp_w9Ts8jmOzQczYwANodV=HerCm=w@mail.gmail.com>
 <858849309.1558836.1479828683078.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753368AbcKVQBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 11:01:01 -0500
Content-Disposition: inline
In-Reply-To: <858849309.1558836.1479828683078.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Eyal Ben David <bdeyal@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Tue, Nov 22, 2016 at 10:31:23AM -0500, Laurence Oberman wrote:
[...]

> Its not failing on 4.8-rc2 so working on tracing rgw ioctl SG_DXFER_FROM_DEV as well and will bisect this weekend and/or add some kernel probes.
> Just need to get some time.
> Johannes or Ewan may beat me to it.

Sounds like a good plan. I did work on an automated test setup all day but
couldn't recreate the bug with qemu (and it's default AHCI emulation, will
try virtio-scsi tomorrow).

@Eyal is this with a physical or virtual host? And what kind of HBA do you
have? Just in case it makes a difference.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
