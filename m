From: James Morris <jmorris@redhat.com>
Subject: Re: [PATCH] Add CRC32C chksums to crypto routines
Date: Mon, 19 Jan 2004 16:33:12 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Xine.LNX.4.44.0401191632001.2019-100000@thoron.boston.redhat.com>
References: <yquj8yk31vxy.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <yquj8yk31vxy.fsf@chaapala-lnx2.cisco.com>
To: Clay Haapala <chaapala@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 19 Jan 2004, Clay Haapala wrote:

> In other email, Matt Mackall suggested a slightly different
> integration with the kernel that would allow more general usage of the
> CRC32C.  His suggestion was to put the implementation under /lib, next
> to the crc32 routines, and make the crypto routine a wrapper that calls
> it.  Selecting the CRYPTO_CRC32C module would SELECT the lib CRC32C
> module, in other words.
> 
> The benefit of this would be to allow easy usage by other routines
> (with no premption side-affects, a concern Matt has) while still being
> there for routines that process scatterlist.  And the table/code is
> still in one place.
> 
> Patch to follow in a day or two, after I can test it.  Implementation
> was simple.

Sounds good -- the inflate/deflate algorithms do this as well.


- James
-- 
James Morris
<jmorris@redhat.com>
