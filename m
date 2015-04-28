From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Tue, 28 Apr 2015 11:18:11 +0200
Message-ID: <20150428111811.0000556e@localhost>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Kardashevskiy <aik@ozlabs.ru>, Sebastian Herbszt <herbszt@gmx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Smart <james.smart@emulex.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alexey Kardashevskiy wrote:
> This reverts 4fbdf9cb is breaks LPFC on POWER7 machine, big endian kernel.
> 
> This is the hardware used for verification:
> 0005:01:00.0 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)
> 0005:01:00.1 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

This issue is not specific to POWER7. I hit it on x86 [1] and James
promised to look at it.

[1] http://marc.info/?l=linux-scsi&m=142938432414173

Sebastian
