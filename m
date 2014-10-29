From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/36] ncr5380: Remove redundant AUTOSENSE macro
Date: Wed, 29 Oct 2014 16:57:11 +0100
Message-ID: <54510E57.5070408@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052609.075424749@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052609.075424749@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Every NCR5380 driver sets AUTOSENSE so it need not be optional (and the
> mid-layer expects it). Remove this redundant macro to improve readability.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
