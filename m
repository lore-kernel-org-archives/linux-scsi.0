From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 16:44:34 +0100
Message-ID: <20161121154434.g2d434yilg7sfj77@linux-x5ow.site>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain>
 <CAPrnrPCkXPDWDpbt3HxsTWEoKGt-Atnk2QtJKX4tmG_AeDx8Lw@mail.gmail.com>
 <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754219AbcKUPoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 10:44:37 -0500
Content-Disposition: inline
In-Reply-To: <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: emilne@redhat.com, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Mon, Nov 21, 2016 at 04:15:52PM +0100, Johannes Thumshirn wrote:
> On Mon, Nov 21, 2016 at 04:55:29PM +0200, Eyal Ben David wrote:
> > Thanks for your reply,
> > 
> > On RHEL system it does not occur.
> > 
> > So far I have seen the problem on Ubuntu 16.04 and Fedora 22 (both
> > with kernel 4.4.x)

As Ewan already pointed out, do you have commit
5ecee0a3ee8d74b6950cb41e8989b0c2174568d4 applied in your kernels? It went in
4.6 and got stable backported from there till 2.6.something. I'm trying this
patch myself to see whether it is the required change or not.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
