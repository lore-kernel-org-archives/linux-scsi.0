Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BCCC43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7CC320833
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfLDOFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:05:33 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:50247 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfLDOFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 09:05:32 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MirX2-1i6Rn50Zng-00ev0t; Wed, 04 Dec 2019 15:05:31 +0100
Received: by mail-qk1-f175.google.com with SMTP id q28so7198988qkn.10;
        Wed, 04 Dec 2019 06:05:30 -0800 (PST)
X-Gm-Message-State: APjAAAUsxupyB35Eg91X2CCVgjevsbc+DPAi1dkr6WyAuKf85HWRPZ9N
        OmU1XbjO2IHuTdIRgkv+tYx664ym8c9qeVZsQcc=
X-Google-Smtp-Source: APXvYqx7JslI8mWkoxNJ0fjl5MarFjwC/GOiLTgjegA+w4l2OCEv4HdCV/vhy3jf8P3GwW/qYyA89iXWINrzIH936oc=
X-Received: by 2002:ae9:eb12:: with SMTP id b18mr2945260qkg.3.1575468329900;
 Wed, 04 Dec 2019 06:05:29 -0800 (PST)
MIME-Version: 1.0
References: <1575137443.5563.18.camel@HansenPartnership.com> <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
In-Reply-To: <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 4 Dec 2019 15:05:09 +0100
X-Gmail-Original-Message-ID: <CAK8P3a33oETbN-60VjpNNeuW1U1Wzb4juVzdiw1ESdses6m3bw@mail.gmail.com>
Message-ID: <CAK8P3a33oETbN-60VjpNNeuW1U1Wzb4juVzdiw1ESdses6m3bw@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.4+ merge window
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:PrJhNMzdEgu7HmHaW+4RW1cXQjySBFOSIdr0MN+9q8+AAumf1ZC
 /TtNLgSii9Az1L54qsdqb0uigh2N6vR0vs4+82h5TlbWTett89W8mB/GZo9Mg6FUXdUpH24
 bSN1WLvdmqoEvPBYf78vkh41nVblJYfnTg4eTqc2S9aRZQRmIeSaOjJN9+4WxtPOZya03QE
 qSY9EUxrqm5ulPtPdUbag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lFv8KiEf6Aw=:YEgixR4fabBY/FVMQbUVqM
 lZY7gBr2acWKbCobF3jNMCJK+ls92OP09fAd73jHzRkoyna8it37BiRle7KLp2LRO31/Ro1U+
 U8+0+PO4lTleqRLK7Xyfzu/mENEVSZ7LdOl+OSmDhytga9Nuiuf1IvM/53s7y5sfbNIUY8Mfq
 3kBKLqZNNnXU+Od+PhiczIjxDt+u7Y3W0H4C0NLnqANQ7ehALKiqRVW0s+QrpIdzPkh8CXZvX
 iDc2p6KRJQXRPdO836rKCitcoSc6eTXe5tTXxgyN4dL0qbd175BCTa+lm+2FxCUwNJn7mFYZS
 9nya4sxsEg8sMJhOvZ5LMARY4uln+at0p10Sz8FozrzFebjsOZheFMqWIHDq3sCpjFBqW5J1t
 s5YUFYcEsCsJaHjk9VcUrwr4TOCZtbf1qtaS96FMNve+PhbfKAGoaDHCyneqVtpd41LtgBKCG
 AEuFvaxCWjTg7nU/E4LVvVDptjVZkpEbjTvGlGo+caV2XsuzhGl3y9esZ83zHEGnEy8gnCk9m
 4KNq1F6ysMfK47q6IifGdp2VDdG8hFWGFtReLGR48AHMEyiOElt8GHe3ZZAGChKtHormBaevt
 NlgGWRbHj1yNiIpEdgQXoOUfTTrqn/D3cEbIkvPpy2i4qM/kOPlvo4huw2dimCaRKwX0lnMM+
 I0E1wZL8E34PsMRi8BY623L4ssrcNZMThWMOY9sIDuPilqw4aeF+TyWKy/Y4rTXFdNelTFyVh
 xxQATf0Vml7RznJ+KaOmUnhrj1NDoFpNw4sw9BC5XjJvIHiaLiptOvFvN38i4rQoFioN8O+Ct
 I6Qyv2CysvUW6Ia7uwyghGZEPVavUvUukZdtAvXTIDKDyka7dOXSkHBY7se1FikYQLsfF2GXR
 iumaF+m0hcsOd0Ta94MQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 2, 2019 at 10:58 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, the sg copyin/out changes by Al conflicted fairly badly with
> Arnd's compat_ioctl changes.
>
> Al did
>
>   c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of
> userland sg_io_hdr_t")
>
> which avoided doing a whole allocation of an 'sg_io_hdr_t' to just
> read the one field of it.
>
> But Arnd did
>
>   98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
>
> which created a get_sg_io_hdr() helper that copied the 'sg_io_hdr_t'
> from user space the right way for both compat and native, which
> basically relied on the old approach.

Right, I also failed to notice that the linux-next conflict resolution
was breaking my changes, the fixup looked simple enough there. :-(

> since it turns out that the one 'pack_id' field we want does have the
> same format in compat  mode as in native mode ("int" and
> "compat_int_t" are the same), it's just at different offsets. But the
> definition of 'compat_sg_io_hdr' isn't available in that place.
>
> I'm leaving it to Al and Arnd to decide if they want to fix the
> stupidity. I tried to make the minimally invasive merge resolution.
>
> Al, Arnd? Comments?
>
> It looks like linux-next punted on this entirely, and took Al's
> simplified version that doesn't work with the compat case. Maybe I
> should have done the same - if you use read() on the /dev/sg* device,
> you deserve to get broken for the compat case. And it didn't
> historically work anyway. But it was kind of sad to see how Arnd fixed
> it, and then it got broken again.

I've tried now to move the pack_id logic into a separate function
and, in doing so noticed a bug in my own patch: sg_new_read()
needs to check for the compat_sg_io_hdr size, which also
depends on the struct definition. I've drafted a patch that should
do this right, but we could also just -EINVAL in compat mode here
if that's too complex.

       Arnd
