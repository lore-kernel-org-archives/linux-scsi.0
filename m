From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 18:04:24 +0200
Message-ID: <CAPrnrPD1GxLE_GpOHLZMjhhoXDYkgv_SZXrWFb+dFwihhKgUYQ@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain> <CAPrnrPCkXPDWDpbt3HxsTWEoKGt-Atnk2QtJKX4tmG_AeDx8Lw@mail.gmail.com>
 <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site> <20161121154434.g2d434yilg7sfj77@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36543 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932267AbcKUQEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 11:04:25 -0500
Received: by mail-io0-f194.google.com with SMTP id k19so7200525iod.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 08:04:25 -0800 (PST)
In-Reply-To: <20161121154434.g2d434yilg7sfj77@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: emilne@redhat.com, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

I am using the disro kernels, don't know if they have the patch.

Our IO testing utility use the same pattern (mmap + non-null dxferp) for
a long time, on RHEL 6.x, 7.x and Ubuntu 12.04, 14.04 without a problem,
long before the patch was applied.

Thanks,
Eyal


2016-11-21 17:44 GMT+02:00 Johannes Thumshirn <jthumshirn@suse.de>:
> On Mon, Nov 21, 2016 at 04:15:52PM +0100, Johannes Thumshirn wrote:
>> On Mon, Nov 21, 2016 at 04:55:29PM +0200, Eyal Ben David wrote:
>> > Thanks for your reply,
>> >
>> > On RHEL system it does not occur.
>> >
>> > So far I have seen the problem on Ubuntu 16.04 and Fedora 22 (both
>> > with kernel 4.4.x)
>
> As Ewan already pointed out, do you have commit
> 5ecee0a3ee8d74b6950cb41e8989b0c2174568d4 applied in your kernels? It went=
 in
> 4.6 and got stable backported from there till 2.6.something. I'm trying t=
his
> patch myself to see whether it is the required change or not.
>
> Byte,
>         Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
