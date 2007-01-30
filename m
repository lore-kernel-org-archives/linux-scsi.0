From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
Date: Mon, 29 Jan 2007 18:16:40 -0600
Message-ID: <1170116201.3378.29.camel@mulgrave.il.steeleye.com>
References: <45BD522F.3070706@shaw.ca>
	 <20070129154706.dfb3edab.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070129154706.dfb3edab.akpm@osdl.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-01-29 at 15:47 -0800, Andrew Morton wrote:
> What we don't want to happen is for those disks to spin down during a
> reboot.
> It seems that this is OK with this patch.
> 
> Also, we probably don't want them to be spun down during a kexec_load,
> but
> I expect that's OK too.

Actually, there's another case where we don't want to do spin down, and
that's when we don't own the disc (think external array on a SAN).
Telling this has always been the biggest stumbling block to spin down of
SCSI devices.

There's a patch similar to yours which takes this into account, which is
currently under discussion:

http://marc.theaimsgroup.com/?t=116922621200002

James


