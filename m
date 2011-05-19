From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Wed, 18 May 2011 21:16:49 -0700
Message-ID: <BANLkTimDktq8SxOU3HZkPpj=J9pdkzVX-w@mail.gmail.com>
References: <20110504115324.GE17855@lsi.com> <1305616571.6008.23.camel@mulgrave.site>
 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
 <20110518041551.GL15227@parisc-linux.org> <1305692584.2580.3.camel@mulgrave.site>
 <1305702010.2781.33.camel@pasglop> <mpt2sas-writeq-powerpc64@mdm.bga.com>
 <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com> <x86-32-writeq-is-broken@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x86-32-writeq-is-broken@mdm.bga.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milton Miller <miltonm@bga.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux scsi dev <linux-scsi@vger.kernel.org>, "paulus@samba.org" <paulus@samba.org>, linux powerpc dev <linuxppc-dev@lists.ozlabs.org>, linux pci <linux-pci@vger.kernel.org>, linux kernel <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 18, 2011 at 11:31 AM, Milton Miller <miltonm@bga.com> wrote:
> So the real question should be why is x86-32 supplying a broken writeq
> instead of letting drivers work out what to do it when needed?

Sounds a lot like what I was asking a couple of years ago :)
http://lkml.org/lkml/2009/4/19/164

But Ingo insisted that non-atomic writeq would be fine:
http://lkml.org/lkml/2009/4/19/167

 - R.
