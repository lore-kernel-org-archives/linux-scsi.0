From: James Morris <jmorris@redhat.com>
Subject: Re: [PATCH 2.6.1 -- take two] Add CRC32C chksums to crypto and lib
 routines
Date: Tue, 3 Feb 2004 15:17:12 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Xine.LNX.4.44.0402031511420.1645-100000@thoron.boston.redhat.com>
References: <20040203192711.GB31138@waste.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040203192711.GB31138@waste.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Clay Haapala <chaapala@cisco.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Feb 2004, Matt Mackall wrote:

> > >> +static inline void crypto_chksum_final(struct crypto_tfm *tfm, u32 *out)
> > >> +{
> > >> +	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CHKSUM);
> > > 
> > > A lot of these BUG_ONs seem to be overkill. You're not going to get
> > > here by someone accidentally misusing the interface. You can only get
> > > here by some very willful abuse of the interface or by extremely
> > > unlikely fandango on core, neither of which is worth trying to defend
> > > against.
> > 
> > That would be a worth changing in a clean-up pass over all of
> > crypto, then.
> 
> I'll do them if James has no objections. I've got a couple other
> crypto bits queued.

The problem is that someone could make a programming mistake, not see any 
errors, and get bad crypto.


- James
-- 
James Morris
<jmorris@redhat.com>
