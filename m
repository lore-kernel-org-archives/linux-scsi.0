From: James Morris <jmorris@redhat.com>
Subject: Re: [PATCH] Add CRC32C chksums to crypto routines
Date: Wed, 14 Jan 2004 16:45:49 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Xine.LNX.4.44.0401141643560.12649-100000@thoron.boston.redhat.com>
References: <yqujisje43q9.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <yqujisje43q9.fsf@chaapala-lnx2.cisco.com>
To: Clay Haapala <chaapala@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 14 Jan 2004, Clay Haapala wrote:

> This patch against 2.6.1 adds CRC32C checksumming capabilities to the
> crypto routines.  The structure of it is based wholly on the existing
> digest (md5) routines, the main difference being that chksums are
> often used in an "accumulator" fashion, effectively requiring one to
> set the seed, and the digest algorithms don't do that.

This looks interesting; do you know of any other chksum algorithms which
might need to be implemented in the kernel?


- james
-- 
James Morris
<jmorris@redhat.com>
