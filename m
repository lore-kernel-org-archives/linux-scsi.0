From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic79xx should be able to ignore HostRAID enabled adapters
Date: Thu, 01 Dec 2005 00:22:43 -0800
Message-ID: <438EB2D3.6030605@us.ibm.com>
References: <438E90DD.3010007@us.ibm.com> <438E9B24.9020806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751644AbVLAIWq@vger.kernel.org>
In-Reply-To: <438E9B24.9020806@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Chris McDermott <lcm@us.ibm.com>, Luvella McFadden <luvella@us.ibm.com>, AJ Johnson <blujuice@us.ibm.com>, Kevin Stansell <kstansel@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff,

Good, this was the exact response that I was hoping for, as I've been told to
convince Adaptec to drop the binary RAID drivers in favor of helping out dmraid
development instead.  That process will probably be difficult, but at least I
now have incontrovertible proof that nobody will bend over backwards to support
them and that dmraid is the way to go.  Not that I'm terribly surprised by this.

I would, however, like to apologize for all this churlishness.  Hopefully some
day I won't have to deal with these binary modules altogether, and I won't have
to resort to such methods to get vendors to Do the Right Thing(tm).

--D

(A pity that dmraid doesn't do hostraid right now, otherwise none of this would
be necessary.)

Jeff Garzik wrote:

> This is the correct behavior.  Under Linux, the driver should export
> only the underlying hardware, and nothing more.  This is how all the
> SATA controller drivers function, and this is how aic79xx functions.
> 
> Use a tool such as 'dmraid' for vendor-proprietary RAID solutions.
> 
> Your patch is therefore strongly NAK'd.
> 
>     Jeff
